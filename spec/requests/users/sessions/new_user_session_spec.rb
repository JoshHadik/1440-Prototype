RSpec.describe "REQUEST: New user session (GET /users/sign_in)", type: :request do
  simulation(:get_new_user_session) do
    get new_user_session_path
  end

  context 'when user is not signed in' do
    it 'renders the devise/sessions/new template' do
      simulate(:get_new_user_session)
      expect(response).to render_template("devise/sessions/new")
    end
  end

  context 'when user is already signed in' do
    before { sign_in_as_user }

    it 'redirects to the root path' do
      simulate(:get_new_user_session)
      expect(response).to redirect_to(root_path)
    end
  end
end
