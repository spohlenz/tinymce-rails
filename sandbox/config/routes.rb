Sandbox::Application.routes.draw do
  controller "editor" do
    get :helpers
    get :manual
  end

  root :to => "editor#index"
end
