Rails.application.routes.draw do
  resources :cvhs_lockers

  root "cvhs_lockers#disclaimer"

  get 'success' => "cvhs_lockers#success"

  get 'download' => "cvhs_lockers#download"

  get 'new' => "cvhs_lockers#new"

end
