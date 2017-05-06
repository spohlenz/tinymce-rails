Sandbox::Application.routes.draw do
  controller "editor" do
    get :helpers
    get :jquery
    get :standalone
  end

  root :to => "editor#index"
end
