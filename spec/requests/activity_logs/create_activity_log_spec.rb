RSpec.describe "REQUEST: Create activity log (POST /activity_logs)", type: :request do
  simulation(:create_activity_log) do |with:{}|
    post activity_logs_path, params: { activity_log: with }
    reload_user if signed_in_user
  end

  let(:valid_attributes) do
    FactoryBot.attributes_for(:activity_log).except(:user)
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:activity_log, :invalid).except(:user)
  end

  context 'when user is not signed in' do
    it 'does not create an activity log' do
      expect_simulation(:create_activity_log, with: valid_attributes).to_not create_a_new(ActivityLog)
    end

    it 'redirects to the sign in page' do
      simulate(:create_activity_log)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is signed in' do
    before { sign_in_as_user }

    context 'and tries to create an activity log with valid attributes' do
      it 'creates a new activity log with expected attributes' do
        expect_simulation(:create_activity_log, with: valid_attributes).to create_a_new(ActivityLog)
        new_activity_log = signed_in_user.activity_logs.last
        expect(new_activity_log).to match_attributes(valid_attributes)
      end

      it 'redirects to the new activity log' do
        simulate(:create_activity_log, with: valid_attributes)
        new_activity_log = signed_in_user.activity_logs.last
        expect(response).to redirect_to(new_activity_log)
      end
    end

    context 'and tries to create an activity log with invalid attributes' do
      it 'does not create a new activity log' do
        expect_simulation(:create_activity_log, with: invalid_attributes).to_not create_a_new(ActivityLog)
      end

      it 'renders the new activity log page' do
        simulate(:create_activity_log, with: invalid_attributes)
        expect(response).to render_template("activity_logs/new")
      end
    end
  end
end
