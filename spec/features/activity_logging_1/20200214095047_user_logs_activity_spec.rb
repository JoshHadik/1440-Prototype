RSpec.feature 'FEATURE: User logs activity' do
  before do
    sign_in_as_user
    load_page :new_activity_log_page
  end

  #### SCENARIOS ####

  scenario 'with valid attributes' do
    when_i_post_an_activity_log_with valid_attributes
    then_i_should_see_activity_log_information_for valid_attributes
    and_i_should_see_content_for :activity_log_created
  end

  scenario 'with no attributes' do
    when_i_post_an_activity_log_with no_attributes
    then_i_should_stay_on_the_new_activity_log_page
    and_i_should_see_content_for :label_cant_be_blank, :started_at_cant_be_blank, :ended_at_cant_be_blank
  end

  #### SCENARIO METHODS ####

  # WHENS #
  define_method :when_i_post_an_activity_log_with do |info|
    current_page.fill_in_new_activity_log_form_with info
    current_page.submit_new_activity_log_form
  end

  # THENS #
  define_method :then_i_should_see_activity_log_information_for do |info|
    expect(page).to have_content info[:started_at]
    expect(page).to have_content info[:ended_at]
    expect(page).to have_content info[:label]
  end

  define_method :then_i_should_stay_on_the_new_activity_log_page do
    expect(page).to have_content("New Activity Log").and have_css("form.new_activity_log")
  end

  #### STATE ####


  let(:content) do
    {
      activity_log_created: "Activity log was successfully created",
      label_cant_be_blank: "Label can't be blank",
      started_at_cant_be_blank: "Started at can't be blank",
      ended_at_cant_be_blank: "Ended at can't be blank"
    }
  end

  let(:valid_attributes) do
    FactoryBot.attributes_for(:activity_log)
  end

  let(:no_attributes) do
    {}
  end
end
