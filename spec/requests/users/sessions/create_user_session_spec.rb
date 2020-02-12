RSpec.describe "REQUEST: Create user session (POST /users/sign_in)", type: :request do
  simulation(:user_sign_in) do |with:{}|
    post user_session_path(params: with)
  end

  let(:user_attributes) do
    FactoryBot.attributes_for(:user)
  end

  let!(:user) do
    FactoryBot.create(:user, user_attributes)
  end

  let(:valid_credentials) do
    { user: user_attributes.without(:password_confirmation) }
  end

  let(:invalid_credentials) do
    valid_credentials[:user].merge(password: nil)
  end

  context 'when user is not signed in' do
    context 'and signs in with correct email and password' do
      it 'signs the user in' do
        simulate(:user_sign_in, with: valid_credentials)
      end

      it 'redirects to the root path' do
        simulate(:user_sign_in, with: valid_credentials)
        expect(response).to redirect_to(root_path)
      end
    end

    context 'and signs in with invalid attributes' do
      it 'does not set the user session information' do
        update_session_variables
        expect do
          simulate(:user_sign_in, with: invalid_credentials)
        end.to_not change { session.to_hash["warden.user.user.key"] }.from(nil)
      end

      it 'renders the sign in template' do
        simulate(:user_sign_in, with: invalid_credentials)
        expect(response).to render_template("devise/sessions/new")
      end
    end
  end

  context 'when user is already signed in' do
    before { sign_in_as_user }

    it 'does not change the session\'s user id' do
      update_session_variables
      expect do
        simulate(:user_sign_in, with: valid_credentials)
      end.to_not change { session.to_hash["warden.user.user.key"] }
    end

    it 'redirects to root path' do
      simulate(:user_sign_in, with: valid_credentials)
      expect(response).to redirect_to(root_path)
    end
  end
end
