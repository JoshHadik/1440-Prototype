RSpec.feature 'FEATURE: User signs in' do
  subject do
    FactoryBot.create(:user)
  end

  before do
    load_page :sign_in_page
  end

  #### SCENARIOS ####

  scenario 'with valid email and password' do
    when_i_sign_in_with valid_credentials
    then_i_should_be_sent_to_the_home_page
    and_i_should_see_content_for :successful_sign_in
  end

  scenario 'with invalid email or password' do
    when_i_sign_in_with incorrect_password
    then_i_should_stay_on_the_sign_in_page
    and_i_should_see_content_for :invalid_credentials
  end

  #### SCENARIO METHODS ####

  define_method :when_i_sign_in_with do |credentials|
    current_page.fill_sign_in_form_with credentials
    current_page.submit_sign_in_form
  end

  define_method :then_i_should_be_sent_to_the_home_page do
    expect(page).to have_current_path(root_path)
  end

  define_method :then_i_should_stay_on_the_sign_in_page do
    expect(page).to have_content("Log in").and have_css("form#new_user")
  end

  #### STATE ####

  let(:content) do
    {
      invalid_credentials: "Invalid Email or password",
      successful_sign_in: devise_message(:sessions, :signed_in),
    }
  end

  let(:valid_credentials) do
    { email: subject.email, password: subject.password }
  end

  let(:incorrect_password) do
    { email: subject.email,
      password: "this is not the correct password" }
  end
end
