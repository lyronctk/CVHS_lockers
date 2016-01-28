Rails.application.routes.draw do
  resources :cvhs_lockers

  root "cvhs_lockers#new"

  get 'success' => "cvhs_lockers#success"

  get 'download' => "cvhs_lockers#download"

end
