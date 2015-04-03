require "serverkit"

RSpec.describe Serverkit::Recipe do
  let(:recipe) do
    described_class.new(recipe_data)
  end

  let(:recipe_data) do
    {}
  end

  describe "#errors" do
    subject do
      recipe.errors
    end

    describe "with invalid typed recipe data" do
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
  end
end
