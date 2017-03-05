module ActiveModel
  module Validations
    class DimensionValidator < EachValidator
      DIMENSIONS = [:width, :height, :aspect_ratio].freeze

      CHECKS = { greater_than: :>, greater_than_or_equal_to: :>=,
                 equal_to: :==, less_than: :<, less_than_or_equal_to: :<= }.freeze

      def check_validity!
        options.slice(*DIMENSIONS).each do |dimension, dimension_options|
          if dimension_options.empty?
            raise ArgumentError, "You must at least pass in one of these options for #{dimension} - #{CHECKS.keys.join(', ')}"
          end

          dimension_options.slice(*CHECKS.keys).each do |option, value|
            unless value.is_a?(Numeric) || value.is_a?(Proc) || value.is_a?(Symbol)
              raise ArgumentError, ":#{option} of #{dimension} must be a number, a symbol or a proc"
            end
          end
        end
      end

      def validate_each(record, attr_name, value)
        unless with_width_and_height?(value)
          record.errors.add(attr_name, 'dimension.without_width_or_height'.to_sym, filtered_options(value))
          return
        end

        result = {}
        [:width, :height].each do |dimension|
          length = value.send(dimension)
          unless is_number?(length)
            dimension_text = I18n.t(dimension, scope: 'errors.messages.dimension')
            record.errors.add(attr_name, 'dimension.not_a_number'.to_sym, filtered_options(value).merge!(dimension: dimension_text))
            return
          end

          result[dimension] = length
        end
        result[:aspect_ratio] = (result[:width] / result[:height].to_f)

        options.slice(*DIMENSIONS).each do |dimension, dimension_options|
          computed_value = result[dimension]
          dimension_text = I18n.t(dimension, scope: 'errors.messages.dimension')

          dimension_options.slice(*CHECKS.keys).each do |option, option_value|
            case option_value
            when Proc
              option_value = option_value.call(record)
            when Symbol
              option_value = record.send(option_value)
            end

            unless computed_value.send(CHECKS[option], option_value)
              record.errors.add(attr_name, "dimension.#{option}".to_sym, filtered_options(value).merge!(dimension: dimension_text, count: option_value))
            end
          end
        end
      end

      private

      def with_width_and_height?(value)
        value.respond_to?(:width) and value.respond_to?(:height)
      end

      def is_number?(value)
        !parse_value_as_a_number(value).nil?
      rescue ArgumentError, TypeError
        false
      end

      def parse_value_as_a_number(value)
        Kernel.Float(value) if value !~ /\A0[xX]/
      end

      def filtered_options(value)
        filtered = options.except(*CHECKS.keys)
        filtered[:value] = value
        filtered
      end
    end

    module HelperMethods
      def validates_dimension_of(*attr_names)
        validates_with DimensionValidator, _merge_attributes(attr_names)
      end
    end
  end
end
