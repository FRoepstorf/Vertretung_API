require 'rubygems'
require 'httparty'
require 'nokogiri'
require 'open-uri'
require 'database_cleaner'
require 'date'

desc "Fetch timetable from API"
task :fetch_timetable => :environment do
  puts 'Fetching new timetable...'
  response = HTTParty.get('https://iphone.dsbcontrol.de/iPhoneService.svc/DSB/timetables/2411de16-a699-4014-8ab4-5fe9200b2e11')
  doc = Nokogiri::HTML(open(response[0]['timetableurl']))

  if Timetable.last.nil?
    timetable = Timetable.new
    timetable.date = response[0]['timetabledate']
    timetable.group_name = response[0]['timetablegroupname']
    timetable.title = response[0]['timetabletitle']
    timetable.url = response[0]['timetableurl']
    timetable.save!
  end

  if response[0]['timetabledate'] != Timetable.last.date
    timetable = Timetable.new
    timetable.date = response[0]['timetabledate']
    timetable.group_name = response[0]['timetablegroupname']
    timetable.title = response[0]['timetabletitle']
    timetable.url = response[0]['timetableurl']
    timetable.save!

    if doc.css('table.additionInfoTable + [cellspacing]')[0].css('.alt', '.def').any?
      day1 = doc.css('table.additionInfoTable + [cellspacing]')[0].css('.alt', '.def')
      tag1 = Date.parse(doc.css('h1')[0].text.to_s)

      day1_table = {}
      i = 0

      until i >= day1.count
        temp = {}
        (0..3).each_with_index do |index|
          temp[index] = day1[i].children[index].content
        end
        temp[4] = tag1
        day1_table[i] = temp
        i += 1
      end
    end

    if doc.css('table.additionInfoTable + [cellspacing]')[1].css('.alt', '.def').any?
      day2 = doc.css('table.additionInfoTable + [cellspacing]')[1].css('.alt', '.def')
      tag2 = Date.parse(doc.css('h1')[1].text.to_s)
      day2_table = {}
      i = 0
      until i >= day2.count
        temp = {}
        (0..3).each_with_index do |index|
          temp[index] = day2[i].children[index].content
        end
        temp[4] = tag2
        day2_table[i] = temp
        i += 1
      end
    end

    DatabaseCleaner.clean_with(:truncation, :only => ['changes'])

    i = 0
    until i >= day1_table.count
      change = Change.new
      change.school_class = day1_table[i][0]
      change.hours = day1_table[i][1]
      change.room = day1_table[i][2]
      change.description = day1_table[i][3]
      change.date = day1_table[i][4]
      change.save!
      i += 1
    end

    i = 0
    until i >= day2_table.count
      change = Change.new
      change.school_class = day2_table[i][0]
      change.hours = day2_table[i][1]
      change.room = day2_table[i][2]
      change.description = day2_table[i][3]
      change.date = day2_table[i][4]
      change.save!
      i += 1
    end

    ChangesMailer.mail_change('florian.roepstorf@gmail.com').deliver

    puts 'New data was fetched!'
  end



end