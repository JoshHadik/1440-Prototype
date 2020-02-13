RSpec.feature 'FEATURE: User deletes self' do
  before do
    sign_in_as_user
    load_page :root_page
  end

  #### SCENARIOS ####

  scenario "successfully" do
    when_i_destroy_my_user_credentials
    then_i_should_be_sent_to_the_root_page
    and_i_should_see_content_for :user_destroyed
    and_i_should_not_be_able_to_log_back_in
  end

  #### SCENARIO METHODS ####

  define_method :when_i_destroy_my_user_credentials do
    current_page.delete_account
  end

  define_method :then_i_should_see do |notification|
    expect(page).to have_content notification
  end

  define_method :then_i_should_be_sent_to_the_root_page do
    expect(current_path).to eq(root_path)
  end

  define_method :and_i_should_not_be_able_to_log_back_in do
    load_page :sign_in_page
    current_page.fill_sign_in_form_with({ email: current_user.email, password: current_user.password })
    current_page.submit_sign_in_form
    expect(current_path).to eq(new_user_session_path)
  end

  #### STATE ####
  let(:content) do
    {
      user_destroyed: "Your account has been successfully cancelled"
    }
  end
end
