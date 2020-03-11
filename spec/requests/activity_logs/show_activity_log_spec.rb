RSpec.describe "REQUEST: Show activity log (GET /activity_logs/:id)", type: :request do
  simulation(:show_activity_log) do |with:{}|
    get activity_log_path(with)
  end

  let(:random_activity_log) do
    FactoryBot.create(:activity_log, user: FactoryBot.create(:user))
  end

  context 'when user is not signed in' do
    it 'redirects to the sign in page' do
      simulate(:show_activity_log, with: random_activity_log)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is signed in' do
    before do
      sign_in_as_user
    end

    let(:owned_activity_log) do
      FactoryBot.create(:activity_log, user: signed_in_user)
    end

    context 'and owns the activity log' do
      it 'renders the show template' do
        simulate(:show_activity_log, with: owned_activity_log)
        expect(response).to render_template("activity_logs/show")
      end
    end

    context 'and does not own the activity log' do
      it 'redirects' do
        simulate(:show_activity_log, with: random_activity_log)
        expect(response.status).to eq(302)
      end
    end
  end
end
