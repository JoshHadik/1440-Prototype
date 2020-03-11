RSpec.describe "REQUEST: Destroy activity log (DELETE /activity_logs/:id)", type: :request do
  simulation(:destroy_activity_log) do
    delete activity_log_path(activity_log)
    reload_user if signed_in_user
  end

  let(:activity_log) do
    FactoryBot.create(:activity_log)
  end

  context 'when user is not signed in' do
    it 'does not destroy the activity log' do
      expect_simulation(:destroy_activity_log, with: activity_log).to_not change(ActivityLog, :count)
      expect(ActivityLog.exists?(activity_log.id)).to be(true)
    end

    it 'redirects to the sign in page' do
      simulate(:destroy_activity_log, with: activity_log)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is signed in' do
    before { sign_in_as_user }

    context 'and does not own the activity log' do
      it 'does not destroy the activity log' do
        expect_simulation(:destroy_activity_log, with: activity_log).to_not change(ActivityLog, :count)
        expect(ActivityLog.exists?(activity_log.id)).to be(true)
      end

      it 'redirects' do
        simulate(:destroy_activity_log, with: activity_log)
        expect(response.status).to eq(302)
      end
    end

    context 'and owns the activity log' do
      before { activity_log.update(user: signed_in_user) }
      it 'destroys the activity log' do
        expect_simulation(:destroy_activity_log, with: activity_log).to change(ActivityLog, :count).by(-1)
        expect(ActivityLog.exists?(activity_log.id)).to be(false)
      end

      it 'redirects' do
        simulate(:destroy_activity_log, with: activity_log)
        expect(response.status).to eq(302)
      end
    end
  end

  # When user is not signed in
  # When user is signed in and does not own activity log
  # When user is signed in and owns activity log
end
