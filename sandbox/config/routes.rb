Sandbox::Application.routes.draw do
  match ':action', :controller => "editor"
  root :to => "editor#index"
end
