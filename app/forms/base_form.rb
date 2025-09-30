# frozen_string_literal: true

class BaseForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attr_accessor :record

  def initialize(attributes:)
    @attributes = attributes
    @record = default_record
    super(@attributes)
    assign_attributes_to_record
  end

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      yield(record) if block_given?
      record.save if record_changed?
    end

    return false if propagate_model_errors.present?

    true
  rescue ActiveRecord::RecordInvalid
    false
  end

  def attributes
    super.symbolize_keys
  end

  private

  def default_record
    raise MethodNotImplementedError, ':default_record'
  end

  def assign_attributes_to_record
    record.assign_attributes(attributes_for_creation)
  end

  def attributes_for_creation
    raise MethodNotImplementedError, ':attributes_for_creation'
  end

  def propagate_model_errors
    record.errors.each { |error| errors.add(error.attribute, error.message) }
  end

  def record_changed?
    record.changed?
  end
end
