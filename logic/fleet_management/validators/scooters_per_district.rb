# frozen_string_literal: true

module Logic
  module FleetManagement
    module Validators
      class InvalidScootersPerDistrictError < InvalidArgumentError; end

      #
      # Class ScootersPerDistrict validates scooters per district
      #
      class ScootersPerDistrict
        # could moved out to configuration
        MIN_NO_OF_DISTRICTS = 1
        MAX_NO_OF_DISTRICTS = 100
        MIN_NO_OF_SCOOTERS  = 0
        MAX_NO_OF_SCOOTERS  = 1000

        #
        # Validates scooters_per_district
        #
        # @param [Array] scooters_per_district array of scooter per district
        #
        # @raise InvalidScootersPerDistrictError
        #
        # @return [Array] scooters_per_district
        #
        def self.call(scooters_per_district)
          if !scooters_per_district.is_a? Array
            raise InvalidScootersPerDistrictError, "Scooters per district must be an array of"\
             "length between #{MIN_NO_OF_DISTRICTS} and #{MAX_NO_OF_DISTRICTS},"\
             " each element is integer between #{MIN_NO_OF_SCOOTERS} and #{MAX_NO_OF_SCOOTERS}."
          end

          if !(MIN_NO_OF_DISTRICTS..MAX_NO_OF_DISTRICTS).cover? scooters_per_district.length
            raise InvalidScootersPerDistrictError, "Scooters per district must be an array of"\
             "length between #{MIN_NO_OF_DISTRICTS} and #{MAX_NO_OF_DISTRICTS}."
          end

          invalid_district = scooters_per_district.any? do |district|
            !district.is_a?(Integer) ||
              !(MIN_NO_OF_SCOOTERS..MAX_NO_OF_SCOOTERS).cover?(district)
          end

          if invalid_district
            raise InvalidScootersPerDistrictError, "Scooters per district elements must be "\
             "integer between #{MIN_NO_OF_SCOOTERS} and #{MAX_NO_OF_SCOOTERS}."
          end

          scooters_per_district
        end
      end
    end
  end
end
