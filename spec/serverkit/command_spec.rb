# frozen_string_literal: true

RSpec.describe Serverkit::Command do
  let(:command) do
    described_class.new(argv)
  end

  describe "#call" do
    subject do
      command.call
    end

    context "with validate as 1st argument" do
      let(:argv) do
        ["validate", "recipe.yml"]
      end

      it "calls Serverkit::Actions::Validate action" do
        expect(Serverkit::Actions::Validate).to receive(:new).with(
          hash_including(
            log_level: Logger::INFO,
            recipe_path: "recipe.yml",
          )
        ).and_call_original
        expect_any_instance_of(Serverkit::Actions::Validate).to receive(:call)
        subject
      end
    end
  end
end
