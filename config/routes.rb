Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'twilio#index'

  post 'call' => 'twilio#call'
  post 'connect' => 'twilio#connect'

end
