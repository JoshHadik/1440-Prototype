RSpec.describe "REQUEST: Update activity log (put /activity_logs/:id)", type: :request do
  let(:activity_log) { FactoryBot.create(:activity_log) }

  simulation(:update_activity_log) do |with:{}|
    put activity_log_path(activity_log), params: { activity_log: with }
    reload_user if signed_in_user
  end

  let(:valid_attributes) do
    FactoryBot.attributes_for(:activity_log).except(:user)
  end

  let(:invalid_attributes) do
    FactoryBot.attributes_for(:activity_log, :invalid).except(:user)
  end

  context 'when user is not signed in' do
    it 'does not update the activity log' do
      expect_simulation(:update_activity_log, with: valid_attributes).to_not change {
        activity_log.reload.updated_at.to_s
      }
    end

    it 'redirects to the sign in page' do
      simulate(:update_activity_log, with: valid_attributes)
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is signed in' do
    before { sign_in_as_user }

    context 'and tries to update an activity log they do not own' do
      it 'does not update the activity log' do
        expect_simulation(:update_activity_log, with: valid_attributes).to_not change {
          activity_log.reload.updated_at.to_s
        }
      end

      it 'redirects' do
        simulate(:update_activity_log, with: activity_log)
        expect(response.status).to eq(302)
      end
    end

    context 'and tries to update an activity log they own' do
      before { activity_log.update(user: signed_in_user ) }

      context 'with invalid attributes' do
        it 'does not update the activity log' do
          expect_simulation(:update_activity_log, with: invalid_attributes).to_not change {
            activity_log.reload.updated_at.to_s
          }
        end

        it 'renders the edit activity log page' do
          simulate(:update_activity_log, with: invalid_attributes)
          expect(response).to render_template("activity_logs/edit")
        end
      end

      context 'with valid attributes' do
        it 'updates the activity log' do
          simulate(:update_activity_log, with: valid_attributes)
          expect(activity_log.reload).to match_attributes(valid_attributes)
        end

        it 'redirects to the updated activity log' do
          simulate(:update_activity_log, with: valid_attributes)
          expect(response).to redirect_to(activity_log_path(activity_log.reload))
        end
      end
    end
  end
end
