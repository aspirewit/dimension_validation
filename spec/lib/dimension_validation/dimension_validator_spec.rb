describe ActiveModel::Validations::DimensionValidator do
  class User
    include ActiveModel::Validations
  end

  subject { User }

  def build_validator(options)
    @validator = described_class.new(options.merge(attributes: :avatar))
  end

  described_class::DIMENSIONS.each do |dimension|
    context 'with :greater_than option' do
      let(:dimension_text) { dimension.eql?(:aspect_ratio) ? 'aspect ratio' : dimension.to_s }

      before do
        if dimension.eql?(:aspect_ratio)
          @count = 1.5

          subject.class_eval do
            def default_length
              1.5
            end
          end
        else
          @count = 240

          subject.class_eval do
            def default_length
              240
            end
          end
        end
      end

      context 'as a number' do
        before { build_validator dimension => { greater_than: @count } }

        it { is_expected.to allow_dimension(600, 300, @validator) }
        it { is_expected.not_to allow_dimension(200, 200, @validator, message: "#{dimension_text} must be greater than #{@count}") }
      end

      context 'as a proc' do
        before { build_validator dimension => { greater_than: lambda { |record| @count } } }

        it { is_expected.to allow_dimension(600, 300, @validator) }
        it { is_expected.not_to allow_dimension(200, 200, @validator, message: "#{dimension_text} must be greater than #{@count}") }
      end

      context 'as a symbol' do
        before { build_validator dimension => { greater_than: :default_length } }

        it { is_expected.to allow_dimension(600, 300, @validator) }
        it { is_expected.not_to allow_dimension(200, 200, @validator, message: "#{dimension_text} must be greater than #{@count}") }
      end
    end

    context 'with :greater_than_or_equal_to option' do
      let(:dimension_text) { dimension.eql?(:aspect_ratio) ? 'aspect ratio' : dimension.to_s }

      before do
        if dimension.eql?(:aspect_ratio)
          @count = 2

          subject.class_eval do
            def default_length
              2
            end
          end
        else
          @count = 300

          subject.class_eval do
            def default_length
              300
            end
          end
        end
      end

      context 'as a number' do
        before { build_validator dimension => { greater_than_or_equal_to: @count } }

        it { is_expected.to allow_dimension(600, 300, @validator) }
        it { is_expected.not_to allow_dimension(200, 200, @validator, message: "#{dimension_text} must be greater than or equal to #{@count}") }
      end

      context 'as a proc' do
        before { build_validator dimension => { greater_than_or_equal_to: lambda { |record| @count } } }

        it { is_expected.to allow_dimension(600, 300, @validator) }
        it { is_expected.not_to allow_dimension(200, 200, @validator, message: "#{dimension_text} must be greater than or equal to #{@count}") }
      end

      context 'as a symbol' do
        before { build_validator dimension => { greater_than_or_equal_to: :default_length } }

        it { is_expected.to allow_dimension(600, 300, @validator) }
        it { is_expected.not_to allow_dimension(200, 200, @validator, message: "#{dimension_text} must be greater than or equal to #{@count}") }
      end
    end

    context 'with :equal_to option' do
      let(:dimension_text) { dimension.eql?(:aspect_ratio) ? 'aspect ratio' : dimension.to_s }

      before do
        case dimension
        when :aspect_ratio
          @count = 2

          subject.class_eval do
            def default_length
              2
            end
          end
        when :width
          @count = 600

          subject.class_eval do
            def default_length
              600
            end
          end
        when :height
          @count = 300

          subject.class_eval do
            def default_length
              300
            end
          end
        end
      end

      context 'as a number' do
        before { build_validator dimension => { equal_to: @count } }

        it { is_expected.to allow_dimension(600, 300, @validator) }
        it { is_expected.not_to allow_dimension(200, 200, @validator, message: "#{dimension_text} must be equal to #{@count}") }
      end

      context 'as a proc' do
        before { build_validator dimension => { equal_to: lambda { |record| @count } } }

        it { is_expected.to allow_dimension(600, 300, @validator) }
        it { is_expected.not_to allow_dimension(200, 200, @validator, message: "#{dimension_text} must be equal to #{@count}") }
      end

      context 'as a symbol' do
        before { build_validator dimension => { equal_to: :default_length } }

        it { is_expected.to allow_dimension(600, 300, @validator) }
        it { is_expected.not_to allow_dimension(200, 200, @validator, message: "#{dimension_text} must be equal to #{@count}") }
      end
    end

    context 'with :less_than option' do
      let(:dimension_text) { dimension.eql?(:aspect_ratio) ? 'aspect ratio' : dimension.to_s }

      before do
        if dimension.eql?(:aspect_ratio)
          @count = 1.5

          subject.class_eval do
            def default_length
              1.5
            end
          end
        else
          @count = 240

          subject.class_eval do
            def default_length
              240
            end
          end
        end
      end

      context 'as a number' do
        before { build_validator dimension => { less_than: @count } }

        it { is_expected.to allow_dimension(200, 200, @validator) }
        it { is_expected.not_to allow_dimension(600, 300, @validator, message: "#{dimension_text} must be less than #{@count}") }
      end

      context 'as a proc' do
        before { build_validator dimension => { less_than: lambda { |record| @count } } }

        it { is_expected.to allow_dimension(200, 200, @validator) }
        it { is_expected.not_to allow_dimension(600, 300, @validator, message: "#{dimension_text} must be less than #{@count}") }
      end

      context 'as a symbol' do
        before { build_validator dimension => { less_than: :default_length } }

        it { is_expected.to allow_dimension(200, 200, @validator) }
        it { is_expected.not_to allow_dimension(600, 300, @validator, message: "#{dimension_text} must be less than #{@count}") }
      end
    end

    context 'with :less_than_or_equal_to option' do
      let(:dimension_text) { dimension.eql?(:aspect_ratio) ? 'aspect ratio' : dimension.to_s }

      before do
        if dimension.eql?(:aspect_ratio)
          @count = 1

          subject.class_eval do
            def default_length
              1
            end
          end
        else
          @count = 240

          subject.class_eval do
            def default_length
              240
            end
          end
        end
      end

      context 'as a number' do
        before { build_validator dimension => { less_than_or_equal_to: @count } }

        it { is_expected.to allow_dimension(240, 240, @validator) }
        it { is_expected.not_to allow_dimension(600, 300, @validator, message: "#{dimension_text} must be less than or equal to #{@count}") }
      end

      context 'as a proc' do
        before { build_validator dimension => { less_than_or_equal_to: lambda { |record| @count } } }

        it { is_expected.to allow_dimension(240, 240, @validator) }
        it { is_expected.not_to allow_dimension(600, 300, @validator, message: "#{dimension_text} must be less than or equal to #{@count}") }
      end

      context 'as a symbol' do
        before { build_validator dimension => { less_than_or_equal_to: :default_length } }

        it { is_expected.to allow_dimension(240, 240, @validator) }
        it { is_expected.not_to allow_dimension(600, 300, @validator, message: "#{dimension_text} must be less than or equal to #{@count}") }
      end
    end
  end

  context 'given options' do
    described_class::DIMENSIONS.each do |dimension|
      it "raises argument error if no required argument of #{dimension} was given" do
        expect { build_validator dimension => {} }.to raise_error(ArgumentError)
      end

      described_class::CHECKS.keys.each do |argument|
        it "does not raise argument error if :#{argument} of #{dimension} is a numeric or a proc or a symbol" do
          expect { build_validator dimension => { argument => 120 } }.not_to raise_error
          expect { build_validator dimension => { argument => :default_length }}.not_to raise_error
          expect { build_validator dimension => { argument => lambda { |record| 120 }}}.not_to raise_error
        end

        it "raises error if :#{argument} of #{dimension} is not a number nor a proc or a symbol" do
          expect { build_validator dimension => { argument => [] }}.to raise_error(ArgumentError)
        end
      end
    end
  end
end
