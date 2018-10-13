require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:username_invalid_regex) { build(:user, username: Faker::Name.unique.name) }
  let(:username_too_short) { build(:user, username: 'a') }
  let(:username_too_long) { build(:user, username: 'a' * 51) }
  let(:email_phone_blank) { build(:user, email: nil, phone_number: nil) }

  describe 'validations' do
    context 'custom validator' do
      it 'should have either email or phone presents' do
        expect(email_phone_blank.valid?).to be_falsey
      end
    end

    context 'valid user' do
      it { expect(user.valid?).to be_truthy }
    end

    context 'username' do
      it 'should have valid format' do
        expect(username_invalid_regex.valid?).to be_falsey
      end

      it 'should be more than 2 characters' do
        expect(username_too_short.valid?).to be_falsey
      end

      it 'should be less than 50 characters' do
        expect(username_too_long.valid?).to be_falsey
      end

      it { should validate_presence_of(:username) }

      it 'should be unique' do
        user_dup = build(:user, username: user.username.downcase)
        expect(user_dup.valid?).to be_falsey
      end
    end

    context 'email' do
      it 'should have valid format' do
        expect(build(:user, email: 'foo@bar').valid?).to be_falsey
      end

      it 'should be less than 100 characters' do
        expect(build(:user, email: "foo@b#{'a' * 100}r.com").valid?).to be_falsey
      end

      it 'can be blank' do
        expect(build(:user, email: nil).valid?).to be_truthy
      end

      describe "uniqueness" do
        subject { build(:rand_user, email: user.email) }
        it { should validate_uniqueness_of(:email).case_insensitive }
      end
    end

    context 'phone_number' do
      it 'should have valid format' do
        expect(build(:user, phone_number: 'abcdefg').valid?).to be_falsey
      end

      it 'should be less than 100 characters' do
        expect(build(:user, phone_number: '1' * 21).valid?).to be_falsey
      end

      it 'can be blank' do
        expect(build(:user, phone_number: nil).valid?).to be_truthy
      end

      describe "uniqueness" do
        subject { build(:rand_user, phone_number: user.phone_number) }
        it { should validate_uniqueness_of(:phone_number).case_insensitive }
      end
    end
  end

  describe "after user saved" do
    it 'should set active to true' do
      user.save!
      expect(user.active).to be_truthy
    end

    it 'should set confirmed to true' do
      user.save!
      expect(user.confirmed).to be_truthy
    end

    it 'should set approved to true' do
      user.save!
      expect(user.approved).to be_truthy
    end
  end
end
