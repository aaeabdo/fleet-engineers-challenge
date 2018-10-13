# frozen_string_literal: true

module Logic
  module FleetManagement
    module Validators
      class InvalidArgumentError < ArgumentError; end
    end
  end
end

require_relative './validators/scooters_per_district'
require_relative './validators/fleet_manager_capacity'
require_relative './validators/fleet_engineer_capacity'
