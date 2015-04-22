require "active_model"

class RegexpValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.nil?
      Regexp.new(value)
    end
  rescue RegexpError
    record.errors.add(attribute, "is invalid regexp expression #{value.inspect}")
  end
end
