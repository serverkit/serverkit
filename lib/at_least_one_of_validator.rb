require "active_model"
require "active_support/core_ext/array/conversions"
require "active_support/core_ext/object/try"

class AtLeastOneOfValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    attributes = options[:in] + [attribute]
    if attributes.all? { |name| record.try(name).nil? }
      record.errors.add(attribute, "is required because at least one of #{attributes.to_sentence} are required")
    end
  end
end
