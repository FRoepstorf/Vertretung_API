require 'rails_helper'

RSpec.describe 'Timetables API', type: :request do
  let(:timetables) { create_list :timetable, 10}
  let(:timetable_id) { :timetables.first.id}

  describe 'GET /timetables' do
    before { get '/timetables'}

    it 'returns timetables' do
      expect(JSON.parse(response.body)).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'return status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /timetables/:id' do
    before { get "/timetables/#{timetable_id}" }

    context 'when the record exists' do
      it 'returns the timetable' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(timetable_id)
      end
      it 'return status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:timetable_id) { 100 }

      it 'returns a not found message' do
        expect(response.body).to match("{\"message\":\"Couldn't find Timetable with 'id'=100\"}")
      end
    end
  end

end