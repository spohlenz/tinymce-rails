Sandbox::Application.routes.draw do
  get ':action', :controller => "editor"
  root :to => "editor#index"
end
