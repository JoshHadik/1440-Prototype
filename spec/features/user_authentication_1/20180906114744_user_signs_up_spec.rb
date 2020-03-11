RSpec.feature 'FEATURE: User signs up' do
  before do
    load_page :sign_up_page
  end

  #### SCENARIOS ####

  scenario 'with valid information' do
    when_i_sign_up_with valid_user_attributes
    then_i_should_be_sent_to_the_root_page
    and_i_should_see_content_for :successful_sign_up
  end

  scenario 'without an email' do
    when_i_sign_up_with no_email
    then_i_should_stay_on_the_sign_up_page
    and_i_should_see_content_for :missing_email
  end

  scenario 'with an already used email' do
    when_i_sign_up_with existing_email
    then_i_should_stay_on_the_sign_up_page
    and_i_should_see_content_for :taken_email
  end

  scenario 'with mistmatched password and password confirmation' do
    when_i_sign_up_with mismatched_passwords
    then_i_should_stay_on_the_sign_up_page
    and_i_should_see_content_for :mismatched_passwords
  end

  #### SCENARIO METHODS ####

  define_method :when_i_sign_up_with do |information|
    current_page.fill_sign_up_form_with information
    current_page.submit_sign_up_form
  end

  define_method :then_i_should_be_sent_to_the_root_page do
    expect(page).to have_current_path('/')
  end

  define_method :then_i_should_stay_on_the_sign_up_page do
    expect(page).to have_content("Sign up").and have_css("form#new_user")
  end

  #### STATE ####

  let(:valid_user_attributes) do
    FactoryBot.attributes_for(:user)
  end

  let(:no_email) do
    FactoryBot.attributes_for(:user, email: nil)
  end

  let(:mismatched_passwords) do
    FactoryBot.attributes_for(:user, password_confirmation: "mismatched_password")
  end

  let(:existing_email) do
    FactoryBot.attributes_for(:user, email: existing_user.email)
  end

  let(:existing_user) do
    FactoryBot.create(:user, email: "already@existing.email")
  end

  let(:content) do
    {
      mismatched_passwords: "Password confirmation doesn't match Password",
      missing_email: "Email can't be blank",
      taken_email: "Email has already been taken",
      successful_sign_up: devise_message(:registrations, :signed_up)
    }
  end
end
