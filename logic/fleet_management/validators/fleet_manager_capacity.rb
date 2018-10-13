# frozen_string_literal: true

module Logic
  module FleetManagement
    module Validators
      class InvalidFleetManagerCapacityError < InvalidArgumentError; end

      class FleetManagerCapacity
        MIN_NO_OF_SCOOTERS  = 1
        MAX_NO_OF_SCOOTERS  = 999

        def self.call(fleet_manager_capacity)
          if !fleet_manager_capacity.is_a?(Integer) ||
             !(MIN_NO_OF_SCOOTERS..MAX_NO_OF_SCOOTERS).cover?(fleet_manager_capacity)

            raise InvalidFleetManagerCapacityError, 'Fleet manager capacity must be an integer'\
             " between #{MIN_NO_OF_SCOOTERS} and #{MAX_NO_OF_SCOOTERS}."
          end

          fleet_manager_capacity
        end
      end
    end
  end
end
