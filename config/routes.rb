Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'twilio#index'

  post '/call', to: 'twilio#call', as: 'call'
  post '/connect/:sales_number', to: 'twilio#connect', as: 'connect'

end
