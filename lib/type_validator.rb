require "active_model"

class TypeValidator < ActiveModel::EachValidator
  def options
    super.merge(allow_nil: true)
  end

  def validate_each(record, attribute, value)
    classes = options[:in] || [options[:with]]
    if classes.all? { |klass| !value.is_a?(klass) }
      record.errors.add(attribute, "must be a #{classes.join(' or ')}, not a #{value.class}")
    end
  end
end
