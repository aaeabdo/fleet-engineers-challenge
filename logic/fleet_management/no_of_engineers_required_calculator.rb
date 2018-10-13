# frozen_string_literal: true

module Logic
  module FleetManagement
    class NoOfEngineersRequiredCalculator
      def initialize(
        scooters_per_district_validator,
        fleet_manager_capacity_validator,
        fleet_engineer_capacity_validator
      )
        @scooters_per_district_validator   = scooters_per_district_validator
        @fleet_manager_capacity_validator  = fleet_manager_capacity_validator
        @fleet_engineer_capacity_validator = fleet_engineer_capacity_validator
      end

      def call(scooters_per_district, fleet_manager_capacity, fleet_engineer_capacity)
        validate_arguments!(scooters_per_district, fleet_manager_capacity, fleet_engineer_capacity)

        manager_engineer_ratio = fleet_manager_capacity / fleet_engineer_capacity.to_f
        manager_engineer_ratio_remainder = manager_engineer_ratio.modulo(1)

        max_manager_engineer_coverage = 0
        max_no_engineers_required     = 0

        scooters_per_district.each do |scooters|
          no_engineers_required           = scooters / fleet_engineer_capacity.to_f
          no_engineers_required_remainder = no_engineers_required.modulo(1)

          if scooters <= fleet_manager_capacity &&
            no_engineers_required.ceil > max_manager_engineer_coverage

            max_manager_engineer_coverage = no_engineers_required.ceil
          elsif scooters > fleet_manager_capacity &&
            no_engineers_required_remainder > 0 &&
            no_engineers_required_remainder <= manager_engineer_ratio_remainder &&
            manager_engineer_ratio.ceil > max_manager_engineer_coverage

            max_manager_engineer_coverage = manager_engineer_ratio.ceil
          elsif scooters > fleet_manager_capacity
            no_engineers_required_remainder = 0 &&
            no_engineers_required_remainder > manager_engineer_ratio_remainder &&
            manager_engineer_ratio.floor > max_manager_engineer_coverage

            max_manager_engineer_coverage = manager_engineer_ratio.floor
          end

          max_no_engineers_required += no_engineers_required.ceil
        end

        return 0 if no_engineers_required == 0

        no_engineers_required = max_no_engineers_required - max_manager_engineer_coverage

        no_engineers_required
      end

      private

      attr_reader :scooters_per_district_validator, :fleet_manager_capacity,
        :fleet_engineer_capacity

      def validate_arguments!(
        scooters_per_district,
        fleet_manager_capacity,
        fleet_engineer_capacity
      )
        scooters_per_district_validator.call(scooters_per_district)
        fleet_manager_capacity_validator.call(fleet_manager_capacity)
        fleet_engineer_capacity_validator.call(fleet_engineer_capacity)
      end
    end
  end
end
