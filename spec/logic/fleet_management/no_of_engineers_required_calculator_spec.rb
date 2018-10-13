require 'spec_helper'
require_relative '../../../logic/fleet_management'

RSpec.describe Logic::FleetManagement::NoOfEngineersRequiredCalculator do
  subject(:call) do
    described_class
      .new(
        scooters_per_district_validator,
        fleet_manager_capacity_validator,
        fleet_engineer_capacity_validator
      )
      .call(
        scooters_per_district,
        fleet_manager_capacity,
        fleet_engineer_capacity
      )
  end
  let(:scooters_per_district_validator) do
    class_double('Logic::FleetManagement::Validators::ScootersPerDistrict')
  end
  let(:fleet_manager_capacity_validator) do
    class_double('Logic::FleetManagement::Validators::FleetManagerCapacity')
  end
  let(:fleet_engineer_capacity_validator) do
    class_double('Logic::FleetManagement::Validators::FleetEngineerCapacity')
  end
  let(:scooters_per_district)   { double(:scooters_per_district) }
  let(:fleet_manager_capacity)  { double(:fleet_manager_capacity) }
  let(:fleet_engineer_capacity) { double(:fleet_engineer_capacity) }

  context 'with invalid arguments' do
    let(:error) { RuntimeError }

    context 'when scooters per district is invalid' do
      it 'raises error' do
        expect(scooters_per_district_validator)
          .to receive(:call)
          .with(scooters_per_district)
          .and_raise(error)

        expect { call }.to raise_error(error)
      end
    end

    context 'when fleet manager capacity is invalid' do
      it 'raises error' do
        expect(scooters_per_district_validator)
          .to receive(:call)
          .with(scooters_per_district)
        expect(fleet_manager_capacity_validator)
          .to receive(:call)
          .with(fleet_manager_capacity)
          .and_raise(error)

        expect { call }.to raise_error(error)
      end
    end

    context 'when fleet engineer capacity is invalid' do
      it 'raises error' do
        expect(scooters_per_district_validator)
          .to receive(:call)
          .with(scooters_per_district)
        expect(fleet_manager_capacity_validator)
          .to receive(:call)
          .with(fleet_manager_capacity)
        expect(fleet_engineer_capacity_validator)
          .to receive(:call)
          .with(fleet_engineer_capacity)
          .and_raise(error)

        expect { call }.to raise_error(error)
      end
    end
  end

  context 'with valid arguments' do
    before do
      allow(scooters_per_district_validator)
        .to receive(:call)
        .with(scooters_per_district)
        .and_return(scooters_per_district)
      allow(fleet_manager_capacity_validator)
        .to receive(:call)
        .with(fleet_manager_capacity)
        .and_return(fleet_manager_capacity)
      allow(fleet_engineer_capacity_validator)
        .to receive(:call)
        .with(fleet_engineer_capacity)
        .and_return(fleet_engineer_capacity)
    end

    context 'with no scooter' do
      let(:scooters_per_district)   { [0,0] }
      let(:fleet_manager_capacity)  { 10 }
      let(:fleet_engineer_capacity) { 5 }

      it { is_expected.to eq 0 }
    end

    context 'with scooters' do
      context 'when district scooters is less than fleet manager capacity' do
        let(:scooters_per_district)   { [21] }
        let(:fleet_manager_capacity)  { 22 }
        let(:fleet_engineer_capacity) { 5 }

        it 'sets max manager engineer coverage to the no of engineers required' do
          expect(call).to eq(0)
        end
      end

      context 'when district scooters is equal to the fleet manager capacity' do
        let(:scooters_per_district)   { [21] }
        let(:fleet_manager_capacity)  { 21 }
        let(:fleet_engineer_capacity) { 5 }

        it 'sets max manager engineer coverage to the no of engineers required' do
          expect(call).to eq(0)
        end
      end

      context 'when district scooters is larger than the fleet manager capacity' do
        context 'when no engineers required remainder is in the manager engineer ratio remainder' do
          let(:scooters_per_district)   { [21] }
          let(:fleet_manager_capacity)  { 9 }
          let(:fleet_engineer_capacity) { 4 }

          it 'sets max manager engineer coverage to the ceil of manager engineer ratio' do
            expect(call).to eq(3)
          end
        end

        context 'when no engineers required remainder is out of the manager engineer ratio remainder' do
          let(:scooters_per_district)   { [23] }
          let(:fleet_manager_capacity)  { 10 }
          let(:fleet_engineer_capacity) { 4 }

          it 'sets max manager engineer coverage to the floor of manager engineer ratio' do
            expect(call).to eq(4)
          end
        end
      end
    end

    context 'test case 1' do
      let(:scooters_per_district)   { [15, 10] }
      let(:fleet_manager_capacity)  { 12 }
      let(:fleet_engineer_capacity) { 5 }

      it { is_expected.to eq 3 }
    end

    context 'test case 2' do
      let(:scooters_per_district)   { [11, 15, 13] }
      let(:fleet_manager_capacity)  { 9 }
      let(:fleet_engineer_capacity) { 5 }

      it { is_expected.to eq 7 }
    end
  end
end
