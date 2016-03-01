Rails.application.routes.draw do
  resources :cvhs_lockers

  root "cvhs_lockers#disclaimer"

  get 'success' => "cvhs_lockers#success"

  get 'download' => "cvhs_lockers#download"

  get 'new' => "cvhs_lockers#new"

  get 'index' => "cvhs_lockers#index"

  get 'clear' => "cvhs_lockers#clear_all"

  get 'admin_login' => 'cvhs_lockers#admin_login'

  post 'upload' => 'cvhs_lockers#upload'

  post 'restricted' => "application#changeRestriction"

end
