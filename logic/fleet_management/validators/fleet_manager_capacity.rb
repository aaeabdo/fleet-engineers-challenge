# frozen_string_literal: true

module Logic
  module FleetManagement
    module Validators
      class InvalidFleetManagerCapacityError < InvalidArgumentError; end

      #
      # Class FleetManagerCapacity validates fleet_manager_capacity
      #
      class FleetManagerCapacity
        # could moved out to configuration
        MIN_NO_OF_SCOOTERS  = 1
        MAX_NO_OF_SCOOTERS  = 999

        #
        # Validates fleet_manager_capacity
        #
        # @param [Integer] fleet_manager_capacity no of scooters a manager can maintain
        #
        # @raise InvalidFleetManagerCapacityError
        #
        # @return [Integer] fleet_manager_capacity
        #
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
