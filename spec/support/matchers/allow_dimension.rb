RSpec::Matchers.define :allow_dimension do |width, height, validator, message|
  match do |model|
    value = double('avatar', width: width, height: height)
    allow_any_instance_of(model).to receive(:read_attribute_for_validation).and_return(value)
    dummy = model.new
    validator.validate(dummy)
    if message.present?
      !dummy.errors['avatar'].include?(message[:message])
    else
      dummy.errors.empty?
    end
  end
end
