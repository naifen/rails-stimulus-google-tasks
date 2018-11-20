require "rails_helper"

RSpec.describe UserPolicy do
  subject { described_class.new(user, other_user) }

  let(:other_user) { build(:user) }

  context "when user is not signed-in" do
    let(:user) { nil }

    it { expect { subject }.to raise_error(Pundit::NotAuthorizedError) }
  end

  context "when user is signed-in" do
    let(:user) { other_user }

    permitted_actions = %i[show edit update]

    it { expect { subject }.not_to raise_error }
    it { is_expected.to permit_actions(permitted_actions) }
  end
end
