RSpec.describe ActivityLog, type: :model do
  context "validations:" do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:label) }
    it { is_expected.to validate_presence_of(:started_at) }
    it { is_expected.to validate_presence_of(:ended_at) }
  end

  context "associations:" do
    it { is_expected.to belong_to(:user) }
  end

  context 'schematics:' do
    it {is_expected.to have_db_column(:user_id).of_type(:integer)}
    it {is_expected.to have_db_column(:label).of_type(:string)}
    it {is_expected.to have_db_column(:started_at).of_type(:datetime)}
    it {is_expected.to have_db_column(:ended_at).of_type(:datetime)}
  end

  describe '#belongs_to?' do
    let(:user) do
      FactoryBot.build(:user)
    end

    context 'when activity log belongs to user' do
      before do
        subject.user = user
      end

      it 'returns true' do
        expect(subject.belongs_to?(user)).to be(true)
      end
    end

    context 'when activity log does not belong to user' do
      it 'returns false' do
        expect(subject.belongs_to?(user)).to be(false)
      end
    end
  end

end
