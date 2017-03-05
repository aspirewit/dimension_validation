require 'rspec'
require 'support/matchers/allow_dimension'
require 'dimension_validation'

RSpec.configure do |config|
  config.before { allow($stdout).to receive(:write) }
end
