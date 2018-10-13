# frozen_string_literal: true

module Logic
  module FleetManagement
    module Validators
      class InvalidScooterPerDistrictError < InvalidArgumentError; end
      class ScooterPerDistrict
        MIN_NO_OF_DISTRICTS = 1
        MAX_NO_OF_DISTRICTS = 100
        MIN_NO_OF_SCOOTERS  = 0
        MAX_NO_OF_SCOOTERS  = 1000

        def self.call(scooters_per_district)
          if !scooters_per_district.is_a? Array
            raise InvalidScooterPerDistrictError, "Scooters per district must be an array of"\
             "length between #{MIN_NO_OF_DISTRICTS} and #{MAX_NO_OF_DISTRICTS},"\
             " each element is integer between #{MIN_NO_OF_SCOOTERS} and #{MAX_NO_OF_SCOOTERS}."
          end

          if !(MIN_NO_OF_DISTRICTS..MAX_NO_OF_DISTRICTS).cover? scooters_per_district.length
            raise InvalidScooterPerDistrictError, "Scooters per district must be an array of"\
             "length between #{MIN_NO_OF_DISTRICTS} and #{MAX_NO_OF_DISTRICTS}."
          end

          invalid_district = scooters_per_district.any? do |district|
            !district.is_a?(Integer) ||
              !(MIN_NO_OF_SCOOTERS..MAX_NO_OF_SCOOTERS).cover?(district)
          end

          if invalid_district
            raise InvalidScooterPerDistrictError, "Scooters per district elements must be "\
             "integer between #{MIN_NO_OF_SCOOTERS} and #{MAX_NO_OF_SCOOTERS}."
          end

          return scooters_per_district
        end
      end
    end
  end
end
