module DeviseSpecHelper
  attr_accessor :session, :current_user

  include Warden::Test::Helpers

  def sign_in_as_user
    @current_user = FactoryBot.create(:user)
    sign_in current_user
  end

  def sign_in_as(persona)
    @current_user = FactoryBot.create(:user, persona)
    sign_in current_user
  end

  def sign_out(resource_or_scope)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    logout(scope)
  end

  def devise_message(group, message)
    I18n.t("devise.#{group}.#{message}")
  end

  private

  def sign_in(resource_or_scope, resource = nil)
    resource ||= resource_or_scope
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    login_as(resource, scope: scope)
  end

  def as_user(persona=nil)
    @current_user = FactoryBot.create(:user, persona)
  end

  def inject_session(hash)
    Warden.on_next_request do |proxy|
      hash.each do |key, value|
        proxy.raw_session[key] = value
      end
    end
  end

  def as(persona, account: true)
    @user = FactoryBot.create(:user, persona)
  end
end
