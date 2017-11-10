class ChangesController < ApplicationController
  def index
    @changes = Change.all
    json_response(@changes)
  end
end