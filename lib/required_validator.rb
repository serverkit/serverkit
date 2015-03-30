require "active_model"

class RequiredValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil?
      record.errors.add(attribute, "is required")
    end
  end
end
