RSpec.describe "REQUEST: New user registration (GET /users/sign_up)", type: :request do
  simulation(:visit_sign_up_page) { get new_user_registration_path }

  context 'when user is not signed in' do
    it 'renders the devise/registrations/new template' do
      simulate(:visit_sign_up_page)
      expect(response).to render_template("devise/registrations/new")
    end
  end

  context 'when user is already signed in' do
    before { sign_in_as_user }

    it 'redirects to the root path' do
      simulate(:visit_sign_up_page)
      expect(response).to redirect_to(root_path)
    end
  end
end
