RSpec.describe "REQUEST: (Edit activity log) GET /activity_logs/:id/edit", type: :request do
  simulation(:edit_activity_log) do |with:{}|
    get edit_activity_log_path(with)
  end

  let(:activity_log) do
    FactoryBot.create(:activity_log, user: FactoryBot.create(:user))
  end

  context 'when user is not signed in' do
    it 'redirects to the sign in page' do
      simulate(:edit_activity_log, with: activity_log)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is signed in' do
    before { sign_in_as_user }

    context 'and does not own the activity log' do
      it 'redirects' do
        simulate(:edit_activity_log, with: activity_log)
        expect(response.status).to eq(302)
      end
    end

    context 'and owns the activity log' do
      before { activity_log.update(user: signed_in_user) }
      it 'renders the edit template' do
        simulate(:edit_activity_log, with: activity_log)
        expect(response).to render_template("activity_logs/edit")
      end
    end
  end
end
