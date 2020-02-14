RSpec.describe "REQUEST: (New activity log) GET /activity_logs/new", type: :request do
  simulation(:new_activity_log) do
    get new_activity_log_path
  end

  context 'when user is not signed in' do
    it 'redirects to the sign in page' do
      simulate(:new_activity_log)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is signed in to an account' do
    before { sign_in_as_user }

    it 'renders the new activity log page' do
      simulate(:new_activity_log)
      expect(response).to render_template("activity_logs/new")
    end
  end
end
