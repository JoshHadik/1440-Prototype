RSpec.describe "REQUEST: Delete user registration (DELETE /users)", type: :request do
  simulation(:delete_user) do |with:{}|
    delete user_registration_path
  end

  context 'when user is signed in' do
    before { sign_in_as_user }

    it 'deletes the signed in user' do
      simulate(:delete_user)
      expect(signed_in_user).to be_destroyed
    end

    it 'redirects to the root path' do
      simulate(:delete_user)
      expect(response).to redirect_to(root_path)
    end
  end

  context 'when user is not signed in' do
    it 'is redirects to sign in path' do
      simulate(:delete_user)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
