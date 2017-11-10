class TimetablesController < ApplicationController
  def index
    @timetables = Timetable.all
    json_response(@timetables)
  end

  def show
    @timetable = Timetable.find(params[:id])
    json_response(@timetable)
  end

end
