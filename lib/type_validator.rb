require "active_model"

class TypeValidator < ActiveModel::EachValidator
  def options
    super.merge(allow_nil: true)
  end

  def validate_each(record, attribute, value)
    unless value.is_a?(options[:with])
      record.errors.add(attribute, "must be a #{options[:with]}, not #{value.class}")
    end
  end
end
