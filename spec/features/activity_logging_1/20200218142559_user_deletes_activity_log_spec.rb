RSpec.feature 'FEATURE: User deletes activity log' do
  before do
    sign_in_as_user
    load_page :show_activity_log_page, with: {
      activity_log_id: activity_log.id
    }
  end

  #### SCENARIOS ####

  scenario do
    when_i_delete_an_activity_log
    then_i_should_see_content_for :activity_log_deleted
    # and_i_should_not_be_able_to_view_the_activity_log
    # TODO - Add test for when displaying list of activity logs
  end

  #### SCENARIO METHODS ####

  define_method :when_i_delete_an_activity_log do
    current_page.delete_activity_log
  end

  #### STATE ####

  let(:content) do
    {
      activity_log_deleted: "Activity log was successfully deleted"
    }
  end

  let(:activity_log) do
    FactoryBot.create(:activity_log, user: signed_in_user)
  end
end
