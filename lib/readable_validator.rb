require "active_model"

class ReadableValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless File.readable?(value)
      record.errors.add(attribute, "is unreadable")
    end
  end
end
