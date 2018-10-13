# frozen_string_literal: true

require 'optparse'
require_relative 'logic/fleet_management'

class CLI
  # Make sure to follow Semantic Versioning see: https://semver.org
  VERSION = '1.0.0'.freeze

  class FleetManagementOptions
    MANDATORY_ARGUMENTS = %i[scooters_per_district fleet_manager_capacity fleet_engineer_capacity].freeze
    attr_accessor :scooters_per_district, :fleet_manager_capacity, :fleet_engineer_capacity

    def define_options(parser)
      parser.banner = 'Usage: cli.rb [options]'
      parser.separator ''
      parser.separator 'Calculates the no of required fleet engineer to help manager in a city'
      parser.separator ''
      parser.separator 'required arguments:'

      scooters_per_district_option(parser)
      fleet_manager_capacity_option(parser)
      fleet_engineer_capacity_option(parser)

      parser.separator ''
      parser.separator 'Helpful options:'

      parser.on_tail('-h', '--help', 'Print help') do
        puts parser
        exit(0)
      end

      parser.on_tail('--version', 'Print version') do
        puts VERSION
        exit(0)
      end
    end

    def missing_mandatory_arguments
      MANDATORY_ARGUMENTS.select do |arg|
        send(arg).nil?
      end
    end

    private

    def scooters_per_district_option(parser)
      parser.on('-s', '--spd x,y,z', Array, 'Scooters per district array') do |spd|
        self.scooters_per_district = spd.map(&:to_i)
      end
    end

    def fleet_manager_capacity_option(parser)
      parser.on('-c', '--fmc 10', Integer, 'Fleet manager capacity') do |fmc|
        self.fleet_manager_capacity = fmc
      end
    end

    def fleet_engineer_capacity_option(parser)
      parser.on('-p', '--fec 10', Integer, 'Fleet engineer capacity') do |fec|
        self.fleet_engineer_capacity = fec
      end
    end
  end

  def parse(args)
    options = FleetManagementOptions.new
    OptionParser.new do |parser|
      options.define_options(parser)
      parser.parse!(args)
      handle_missing_mandatory_options(options)
      call_logic(options)
    end
  end

  private

  def call_logic(options)
    calculator = Logic::FleetManagement::NoOfEngineersRequiredCalculator.new(
      Logic::FleetManagement::Validators::ScootersPerDistrict,
      Logic::FleetManagement::Validators::FleetManagerCapacity,
      Logic::FleetManagement::Validators::FleetEngineerCapacity
    )

    begin
      required_no_of_engineers = calculator.call(
        options.scooters_per_district,
        options.fleet_manager_capacity,
        options.fleet_engineer_capacity
      )
    rescue Logic::FleetManagement::Validators::InvalidArgumentError => e
      puts "Invalid argument error: #{e.message}"
      exit(1)
    end

    puts "fleet_engineers: #{required_no_of_engineers}"
    exit(0)
  end

  def handle_missing_mandatory_options(options)
    unless options.missing_mandatory_arguments.empty?
      puts "Missing arguments: #{options.missing_mandatory_arguments.join(', ')}"
      exit(1)
    end
  end
end

cli = CLI.new
ARGV << '-h' if ARGV.empty?
cli.parse(ARGV)
