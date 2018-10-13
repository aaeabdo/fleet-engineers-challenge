require 'spec_helper'
require_relative '../../../../logic/fleet_management/validators'

RSpec.describe Logic::FleetManagement::Validators::FleetEngineerCapacity do
  subject(:call) { described_class.call(capacity) }

  context 'invalid' do
    let(:error_message) do
      'Fleet engineer capacity must be an integer'\
      " between #{described_class::MIN_NO_OF_SCOOTERS} and #{described_class::MAX_NO_OF_SCOOTERS}."
    end

    shared_examples_for 'invalid' do
      it 'raises invalid fleet engineer capacity error' do
        expect { call }.to raise_error(
          Logic::FleetManagement::Validators::InvalidFleetEngineerCapacityError,
          error_message
        )
      end
    end

    context 'when not integer' do
      let(:capacity) { 'test' }

      it_behaves_like 'invalid'
    end

    context 'when it is out of range' do
      context 'when it is smaller' do
        let(:capacity) { described_class::MIN_NO_OF_SCOOTERS - 1 }

        it_behaves_like 'invalid'
      end

      context 'when it is bigger' do
        let(:capacity) { described_class::MAX_NO_OF_SCOOTERS + 1 }

        it_behaves_like 'invalid'
      end
    end
  end

  context 'valid' do
    let(:capacity) { described_class::MAX_NO_OF_SCOOTERS - 1 }

    it { is_expected.to eq capacity }
  end
end
