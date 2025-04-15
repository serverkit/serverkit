# frozen_string_literal: true

require "active_support/core_ext/hash/slice"

RSpec.describe Serverkit::ResourceBuilder do
  let(:recipe) do
    Serverkit::Recipe.new(recipe_data)
  end

  let(:recipe_data) do
    { "resources" => resources }
  end

  let(:resources) do
    [resource_attributes]
  end

  let(:resource_attributes) do
    {
      "destination" => "b",
      "source" => "a",
      "type" => "symlink",
    }
  end

  let(:resource_builder) do
    described_class.new(recipe, resource_attributes)
  end

  describe "#build" do
    subject do
      resource_builder.build
    end

    context "with normal case" do
      it { is_expected.to be_a Serverkit::Resources::Symlink }
    end

    context "with unknown type attribute" do
      let(:resource_attributes) do
        super().merge("type" => "unknown")
      end

      it { is_expected.to be_a Serverkit::Resources::Unknown }
    end

    context "without type attribute" do
      let(:resource_attributes) do
        super().except("type")
      end

      it { is_expected.to be_a Serverkit::Resources::Missing }
    end

    context "with abstract type attribute" do
      let(:resource_attributes) do
        super().merge("type" => "entry")
      end

      it { is_expected.to be_a Serverkit::Resources::Unknown }
    end
  end
end
