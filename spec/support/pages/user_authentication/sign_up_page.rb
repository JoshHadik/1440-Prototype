class PagesSpecHelper::SignUpPage < SitePrism::Page
  set_url "/users/sign_up"

  element :email_field, "#new_user #user_email"
  element :password_field, "#new_user #user_password"
  element :password_confirmation_field, "#new_user #user_password_confirmation"
  element :submit_button, "#new_user input[type='submit']"

  def fill_sign_up_form_with(user_attributes)
    if user_attributes[:email]
      email_field.set user_attributes[:email]
    end

    if user_attributes[:password]
      password_field.set user_attributes[:password]
    end

    if user_attributes[:password_confirmation]
      password_confirmation_field.set user_attributes[:password_confirmation]
    end
  end

  def submit_sign_up_form
    submit_button.click
  end
end
