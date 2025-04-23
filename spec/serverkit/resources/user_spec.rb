# frozen_string_literal: true

RSpec.describe Serverkit::Resources::User do
  let(:recipe) { Serverkit::Recipe.new(resources: [attributes]) }
  let(:attributes) do
    {
      "type" => "user",
    }
  end

  subject { described_class.new(recipe, attributes) }

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
