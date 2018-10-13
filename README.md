## FleetManagement CLI

Simple user-facing command line interface (CLI) for calculating the minimum number of Fleet Engineers required to support the manager

## Prerequisites

**Docker**

**Docker-compose**

## Run the CLI
Using docker compose:
 ```
 $ docker-compose run fleet-management ruby cli.rb
 ```
outputs:
 ```
 Usage: cli.rb [options]

 Calculates the no of required fleet engineers to help fleet manager in a city

 required arguments:
     -s, --spd x,y,z                  Scooters per district array
     -c, --fmc 10                     Fleet manager capacity
     -p, --fec 10                     Fleet engineer capacity

 Helpful options:
     -h, --help                       Print help
         --version                    Print version
 ```

## Examples

1. Test case

 ```
 $ docker-compose run fleet-management ruby cli.rb -s 15,10 -c 12 -p 5
 ```
Output:
 ```
 fleet_engineers: 3
 ```

2. Another test case

  ```
  $ docker-compose run fleet-management ruby cli.rb  -s 11,15,13 -c 9 -p 5
  ```
 Output:
  ```
  fleet_engineers: 7
  ```

## Run the specs
Using docker compose:
 ```
 $ docker-compose run fleet-management rspec
 ```

## Missing 
[ ] Feature specs 
