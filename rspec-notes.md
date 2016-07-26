# RSpec Testing Notes

## Installing
`gem install rspec` Installs Rspec and dependencies  
In app folder `rspec --init` creates spec folders for test files  

## File structure
Place spec files in a similar directory to the code being testes for example if the file is in the lib directory, add a lib directory to the spec folder to place the spec file.

## Starting a new spec file
```ruby
require "spec_helper" # requires the spec helper
require "Zombie" # any files/classes being tested

describe Zombie do # describes what is being tested (typically the class)
  # your examples (tests) go here
  it "is named Ash" do
    zombie = Zombie.new # Creates a new instance
    zombie.name.should == 'Ash' # expectation to test
  end
  it "has no brains" do
    zombie = Zombie.new
    zombie.brains.should < 1
  end
end
```
