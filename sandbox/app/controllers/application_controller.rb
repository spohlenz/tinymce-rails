class ApplicationController < ActionController::Base
  protect_from_forgery

  if respond_to?(:before_action)
    before_action :set_locale
  else
    before_filter :set_locale
  end

private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
