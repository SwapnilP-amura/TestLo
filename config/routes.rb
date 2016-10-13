Rails.application.routes.draw do


  root 'static_pages#home'

  get '/error',to:'static_pages#error',as: :error
  get '/not_found',to:'static_pages#not_found',as: :not_found
  #devise_for :users


  devise_for :users,controllers: { sessions: 'users/sessions' ,passwords: 'users/passwords',
                                    registrations:'users/registrations',confirmations:'users/confirmations'}

    get 'profile/student_dashboard' => 'profiles#student_dashboard', as: :student_dashboard
    get 'profile/employer_dashboard' => 'profiles#employer_dashboard', as: :employer_dashboard

    get 'profile/:id' => 'profiles#show' , as: :profile

  resources :tests do
    member do
     get :activate
     get :privacy
     get :result
    end
    resources :questions ,:only => [:new, :create]
  end

  resources :questions ,:only =>[:show]

#test simulation
  get 'taketest/:test_id' , to: 'enrollments#taketest' , as: :taketest

  get 'taketest/:test_id/finish',to: 'enrollments#finish',as: :finish
  get 'taketest/:test_id/timeup',to: 'enrollments#timeup'
  post 'taketest/:test_id/submit_clicked' ,to: 'enrollments#submit_clicked', as: :submit_clicked

  get 'show_current_question/:id', to: 'enrollments#show_current_question' ,as: :show_current_question


  post 'add_question_to_current_test/:test_id/:question_id' , to: 'tests#add_question_to_current_test' ,as: :add_question_to_current_test
  delete 'remove_question_from_current_test/:test_id/:question_id' , to: 'tests#remove_question_from_current_test' ,as: :remove_question_from_current_test

  get 'enroll_for_test/:test_id' , to: 'enrollments#enroll_for_test',as: :enroll_for_test


  #common for both student and employer
  get 'details/edit',to:'details#edit',as: :edit_details
  # #student_details
  # get '/details/edit_student_details',to:'details#edit_student_details',as: :edit_student_details
  # get '/details/new_student_details',to:'details#new_student_details',as: :new_student_details
  # post '/student_details',to:'details#create_student_details'
  # put '/student_details',to:'details#update_student_details'
  # patch '/student_details',to:'details#update_student_details'
  #
  # #employer_details
  # get '/details/edit_employer_details',to:'details#edit_employer_details',as: :edit_employer_details
  # get '/details/new_employer_details',to:'details#new_employer_details',as: :new_employer_details
  # post '/employer_details',to:'details#create_employer_details'
  # put '/employer_details',to:'details#update_employer_details'
  # patch '/employer_details',to:'details#update_employer_details'

  namespace :student do
    resources :details,only:[:edit,:new,:create,:update]
  end

  namespace :employer do
    resources :details,only:[:edit,:new,:create,:update]
  end

#
#
#   resources :details

  # get 'profiles/student_details',to: 'profiles#student_details'
  # get 'profiles/employer_details',to: 'profiles#employer_details'
  #
  # post 'profiles/student_details',to: 'profiles#student_update'
  # post 'profiles/employer_details',to: 'profiles#employer_update'
  #resources :questions
  #get 'remove_question_from_current_test/:test_id/:question_id' , to: 'tests#remove_question_from_current_test' ,as: :remove_question_from_current_test


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
