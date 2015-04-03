require "serverkit"

RSpec.describe Serverkit::Recipe do
  let(:recipe) do
    described_class.new(recipe_data)
  end

  let(:recipe_data) do
    { "resources" => resources }
  end

  let(:resources) do
    []
  end

  describe "#errors" do
    subject do
      recipe.errors
    end

    context "with invalid typed recipe data" do
      let(:recipe_data) do
        nil
      end

      it "returns InvalidRecipeTypeError" do
        is_expected.to match(
          [
            an_instance_of(Serverkit::Errors::InvalidRecipeTypeError)
          ]
        )
      end
    end

    context "with unknown type resource" do
      let(:resources) do
        [
          {
            "id" => "test",
            "type" => "test",
          },
        ]
      end

      it "returns UnknownTypeResourceError" do
        is_expected.to match(
          [
            an_instance_of(Serverkit::Errors::UnknownResourceTypeError)
          ]
        )
      end
    end
  end
end
