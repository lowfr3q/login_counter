LoginCounter::Application.routes.draw do
  match "users/" => 'users#index', :via => :get
  match "users/login" => 'users#login', :via => :post
  match "users/add" => 'users#add', :via => :post
#Needs to have both post and get for the front-end and back-end functionality.
  match "TESTAPI/resetFixture" => 'users#resetFixture', :via => :post, :via => :get
  match "TESTAPI/unitTests" => 'users#unitTests', :via => :post
  # root :to => "users/index"
end
