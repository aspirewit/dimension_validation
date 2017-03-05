require 'active_model'

require 'dimension_validation/version'
require 'dimension_validation/dimension_validator'

module DimensionValidation
end

locale_path = Dir.glob(File.dirname(__FILE__) + '/dimension_validation/locale/*.yml')
I18n.load_path += locale_path unless I18n.load_path.include?(locale_path)
