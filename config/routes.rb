Rails.application.routes.draw do
  get '/changes', to: 'changes#index'
  get '/timetables', to: 'timetables#index'
end
