require 'spec_helper'

RSpec.describe 'CLI' do
  let(:run_command) { `ruby cli.rb` }

  context 'help' do
    let(:output) do
      <<~OUTPUT
      Usage: cli.rb [options]

      Calculates the no of required fleet engineers to help fleet manager in a city

      required arguments:
          -s, --spd x,y,z                  Scooters per district array
          -c, --fmc 10                     Fleet manager capacity
          -p, --fec 10                     Fleet engineer capacity

      Helpful options:
          -h, --help                       Print help
              --version                    Print version
      OUTPUT
    end

    context 'with option' do
      let(:run_command) { `ruby cli.rb -h` }

      it { expect(run_command).to eq output }
    end

    context 'without option' do
      it { expect(run_command).to eq output }
    end
  end

  context 'version' do
    let(:run_command) { `ruby cli.rb --version` }

    let(:output) { "1.0.0\n" }

    it { expect(run_command).to include output }
  end

  context 'calculate' do
    context 'failure' do
      context 'with missing args' do
        context 'without scooters_per_district' do
          let(:run_command) { `ruby cli.rb -c 10 -p 10` }
          let(:output)      { 'Missing arguments: scooters_per_district' }

          it { expect(run_command).to include output }
        end

        context 'without fleet_manager_capacity' do
          let(:run_command) { `ruby cli.rb -s 1,2 -p 10` }
          let(:output)      { 'Missing arguments: fleet_manager_capacity' }

          it { expect(run_command).to include output }
        end

        context 'without fleet_engineer_capacity' do
          let(:run_command) { `ruby cli.rb -s 1,2 -c 10` }
          let(:output)      { 'Missing arguments: fleet_engineer_capacity' }

          it { expect(run_command).to include output }
        end
      end

      context 'with invalid args' do
        context 'when fleet_engineer_capacity is invalid' do
          let(:run_command) { `ruby cli.rb -s 1,2 -c 10 -p 0` }
          let(:output) do
            'Invalid argument error: Fleet engineer capacity must be an integer between'
          end

          it { expect(run_command).to include output }
        end
      end
    end

    context 'success' do
      let(:run_command) { `ruby cli.rb -s 1,2 -c 10 -p 1` }
      let(:output) do
        'fleet_engineers: 1'
      end

      it { expect(run_command).to include output }
    end
  end
end
