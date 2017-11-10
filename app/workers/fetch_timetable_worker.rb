class FetchTimeTableWorker
  require 'rubygems'
  require 'httparty'
  require 'nokogiri'
  require 'open-uri'
  def perform
    response = HTTParty.get('https://iphone.dsbcontrol.de/iPhoneService.svc/DSB/timetables/2411de16-a699-4014-8ab4-5fe9200b2e11')
    doc = Nokogiri::HTML(open(response[0]['timetableurl']))
    alt_cell = doc.css('.alt')
    alts = {}
    i = alt_cell.count
    until i > alt_cell.count
      (0..3).each_with_index do |index|
        alts[i][index] = alt_cell[i].children[index].content
      end
    end
    puts alts.inspect
  end
end