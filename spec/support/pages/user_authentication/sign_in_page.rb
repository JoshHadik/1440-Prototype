class PagesSpecHelper::SignInPage < SitePrism::Page
  set_url "/users/sign_in"

  element :email_field, "#new_user #user_email"
  element :password_field, "#new_user #user_password"
  element :submit_button, "#new_user input[type='submit']"

  def fill_sign_in_form_with(credentials)
    if credentials[:email]
      email_field.set credentials[:email]
    end

    if credentials[:password]
      password_field.set credentials[:password]
    end
  end

  def submit_sign_in_form
    submit_button.click
  end
end
