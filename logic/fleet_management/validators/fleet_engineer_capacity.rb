# frozen_string_literal: true

module Logic
  module FleetManagement
    module Validators
      class InvalidFleetEngineerCapacityError < InvalidArgumentError; end

      #
      # Class FleetEngineerCapacity validates fleet engineer capacity
      #
      class FleetEngineerCapacity
        # Could moved out to configuration
        MIN_NO_OF_SCOOTERS  = 1
        MAX_NO_OF_SCOOTERS  = 1000

        #
        # Validates fleet_engineer_capacity
        #
        # @param [Integer] fleet_engineer_capacity no of scooters an engineer can maintain
        #
        # @raise InvalidFleetEngineerCapacityError
        #
        # @return [Integer] fleet_engineer_capacity
        #
        def self.call(fleet_engineer_capacity)
          if !fleet_engineer_capacity.is_a?(Integer) ||
             !(MIN_NO_OF_SCOOTERS..MAX_NO_OF_SCOOTERS).cover?(fleet_engineer_capacity)

            raise InvalidFleetEngineerCapacityError, 'Fleet engineer capacity must be an integer'\
             " between #{MIN_NO_OF_SCOOTERS} and #{MAX_NO_OF_SCOOTERS}."
          end

          fleet_engineer_capacity
        end
      end
    end
  end
end
