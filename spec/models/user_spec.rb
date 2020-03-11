RSpec.describe User, type: :model do
  context "validations:" do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to allow_value("josh@gmail.com").for(:email) }
    it { is_expected.to_not allow_value("josh@").for(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.to validate_presence_of(:password) }

    it "is invalid when password doesn't match password confirmation" do
      expect(FactoryBot.build(:user, password_confirmation: "missmatched")).to_not be_valid
    end
  end

  context "associations:" do
    it { is_expected.to have_many(:activity_logs) }
  end

  context 'schematics:' do
    it {is_expected.to have_db_column(:email).of_type(:string)}
    it {is_expected.to have_db_column(:encrypted_password).of_type(:string)}
  end

  subject do
    FactoryBot.create(:user)
  end

  describe '#save_activity_log' do
    context 'when activity log is valid' do
      let(:activity_log) do
        FactoryBot.build(:activity_log)
      end

      it 'adds the activity log to the user\'s activity logs' do
        subject.save_activity_log(activity_log)
        expect(subject.activity_logs.last).to eq(activity_log)
      end
      # expect(new_activity_log).to match_attributes(valid_attributes)

      it 'returns logged activity' do
        expect(subject.save_activity_log(activity_log)).to be(true)
      end
    end

    context 'when activity log is invalid' do
      let(:activity_log) do
        FactoryBot.build(:activity_log, :invalid)
      end

      it 'does not add the prompt to the user\'s prompts' do
        subject.save_activity_log(activity_log)
        expect(subject.activity_logs).to_not include(activity_log)
      end

      it 'returns nil' do
        expect(subject.save_activity_log(activity_log)).to be(false)
      end
    end

  end

  RSpec::Matchers.define :match_attributes do |response_hash|
    match do |resource|
      response_hash.each do |key, value|
        expect(resource.send(key)).to eq(value)
      end
    end
    ## TODO -> Write Error Messages
  end
end
