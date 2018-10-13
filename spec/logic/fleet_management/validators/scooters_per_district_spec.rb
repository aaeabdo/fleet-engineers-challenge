require 'spec_helper'
require_relative '../../../../logic/fleet_management/validators'

RSpec.describe Logic::FleetManagement::Validators::ScootersPerDistrict do
  subject(:call) { described_class.call(scooters_per_district) }

  context 'invalid' do
    shared_examples_for 'invalid' do
      it 'raises invalid fleet manager capacity error' do
        expect { call }.to raise_error(
          Logic::FleetManagement::Validators::InvalidScootersPerDistrictError,
          error_message
        )
      end
    end

    context 'when not array' do
      let(:scooters_per_district) { 'test' }
      let(:error_message) do
        "Scooters per district must be an array of"\
        "length between #{described_class::MIN_NO_OF_DISTRICTS} and"\
        " #{described_class::MAX_NO_OF_DISTRICTS},"\
        " each element is integer between #{described_class::MIN_NO_OF_SCOOTERS} "\
        "and #{described_class::MAX_NO_OF_SCOOTERS}."
      end

      it_behaves_like 'invalid'
    end

    context 'when it is out of range' do
      let(:error_message) do
        "Scooters per district must be an array of"\
        "length between #{described_class::MIN_NO_OF_DISTRICTS} "\
        "and #{described_class::MAX_NO_OF_DISTRICTS}."
      end

      context 'when it is smaller' do
        let(:scooters_per_district) { [] }

        it_behaves_like 'invalid'
      end

      context 'when it is bigger' do
        let(:scooters_per_district) { Array.new(described_class::MAX_NO_OF_DISTRICTS + 1) }

        it_behaves_like 'invalid'
      end
    end

    context 'when element is invalid' do
      let(:scooters_per_district) { Array.new(described_class::MAX_NO_OF_DISTRICTS, district) }
      let(:error_message) do
        "Scooters per district elements must be "\
        "integer between #{described_class::MIN_NO_OF_SCOOTERS} "\
        "and #{described_class::MAX_NO_OF_SCOOTERS}."
      end

      context 'when not integer' do
        let(:district) { 'test' }

        it_behaves_like 'invalid'
      end

      context 'when out of range' do
        context 'when smaller' do
          let(:district) { described_class::MIN_NO_OF_SCOOTERS - 1 }

          it_behaves_like 'invalid'
        end

        context 'when bigger' do
          let(:district) { described_class::MAX_NO_OF_SCOOTERS + 1 }

          it_behaves_like 'invalid'
        end
      end
    end
  end

  context 'valid' do
    let(:scooters_per_district) { Array.new(described_class::MAX_NO_OF_DISTRICTS, district) }
    let(:district)              { described_class::MIN_NO_OF_SCOOTERS }

    it { is_expected.to eq scooters_per_district }
  end
end
