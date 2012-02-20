ExampleUploadsToAwsS3::Application.routes.draw do
  
  resources :documents
  root :to => 'documents#new'

end