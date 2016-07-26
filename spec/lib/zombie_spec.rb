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
