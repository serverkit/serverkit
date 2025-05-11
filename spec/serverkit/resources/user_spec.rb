# frozen_string_literal: true

RSpec.describe Serverkit::Resources::User do
  let(:recipe) { Serverkit::Recipe.new(resources: [attributes]) }

  subject { described_class.new(recipe, attributes) }

  describe "attributes" do
    let(:attributes) do
      { "type" => "user" }
    end

    it { expect(subject.type).to eq "user" }
    it { is_expected.to respond_to :gid }
    it { is_expected.to respond_to :home }
    it { is_expected.to respond_to :name }
    it { is_expected.to respond_to :password }
    it { is_expected.to respond_to :shell }
    it { is_expected.to respond_to :system }
    it { is_expected.to respond_to :uid }
  end

  describe "system" do
    context "system is true" do
      let(:attributes) do
        {
          "type" => "user",
          "system" => true,
        }
      end
      it { expect(subject.system).to be true }
    end

    context "system is false" do
      let(:attributes) do
        {
          "type" => "user",
          "system" => false,
        }
      end
      it { expect(subject.system).to be false }
    end
  end
end
