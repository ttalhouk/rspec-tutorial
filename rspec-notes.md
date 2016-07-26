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

**Matchers**

Other examples
```ruby
zombie.alive.should == false
zombie.alive.should be_false # same as above

zombie.rotting.should == true
zombie.rotting.should be_true

zombie.height.should > 5
zombie.brains.should be < 1
zombie.height.should >= 5
zombie.height.should_not == 5 #testing that it is not
```

*Preticate Matchers*
```ruby
# in zombie class
def hungry?
  true
end

# test can be written
zombie.should be_hungry # calls hungry? on zombie
```

## Configuration and Advanced Matchers

**Configring for Rails**

Add to gem file
```ruby
group :development, :test do
  gem 'rspec-rails'
end
```
`$ bundle install` to run `$rails generate rspec:install` which installs rails version of the spec helper.

spec/spec_helper.rb
```ruby  
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
...
requires all helper files within spec/support
RSpec.configure do |config|
  config.mock_with :mocha # can configure
...
end
```
Other options can be added to .rspec file to run as default such as `--color` and `--format`

Specifiying test to run...
```bash
$ rspec
  // runs all tests
$ rspec spec/models/
  // running all the ‘_spec.rb’ files within /spec
$ rspec spec/models/zombie_spec.rb
  // running a specific directory running a specific test
$ rspec spec/models/zombie_spec.rb:4
  // runs the specific line in the test
```

**Advanced Matcher**

* `valid` used with Activerecord validations tests if an object is valid  
* `include(thing_to_include)` used to test if an item is in an array  
* `have(#).object` checks that the count of an object(cna use have_at_least/at_most)  
* `{}.to change {}` then use `.by .to .from` for testing (can be chained)  
* `{}.to raise_error(the error)` checks that this raises a specific error  
* `respond_to(method)` checks that the method exists
* `be_within(range).of(target)` checks a range of a target   
* `exists` checks that object exists
* `satisfy {}` can send in a block and check if it is true
* `be_kind_of(class)` checks type of class
* `be_an_instance_of(class)` checks type of class


## Organizing examples

Instantiating a new object using subject.  This creates a new object using the class provided in the describe block. Rspec doesn't require using subject, it will infer it if none are provided. So...

```ruby
describe Zombie do
  it 'responds to name' do
    should respond_to(:name) # assumes Zombie.new
  end
end

# this can be shortend to

describe Zombie do
  it { should respond_to(:name) } # Will output readable results
end

# likewise
describe Zombie do
  it { subject.name.should == 'Ash' }
end

# can be written
describe Zombie do
  its(:name) { should_be 'Ash' }

  # other test formats
  its(:weapons) { should include(weapon) }
  its(:brain) { should be_nil }
  its('tweets.size') { should == 2 }
end
```

When using a subject, and using let blocks
```ruby
context 'with a veggie preference' do
  subject (:zombie) { Zombie.new(vegetarian: true, weapons: [axe]) }
  let(:axe) { Weapon.new(name: 'axe') }

    its(:weapons) { should include(axe) } # refers to subject
    it 'can use its axe' do
      zombie.swing(axe).should == true # zombie is alias for subject
  end
end
```
## Hooks and Tags

**Before Hook**
```ruby
describe Zombie do let(:zombie) { Zombie.new }
  before { zombie.hungry! } #applies before all tests and within all contexts
  it 'is hungry' do
    zombie.should be_hungry
  end
  it 'craves brains' do
    zombie.should be_craving_brains
  end
  context 'with a veggie preference' do
    before {zombie.vegetarian = true} # applied within context

    it 'still craves brains' do
      #zombie.vegetarian = true (refactored)
      #...
    end
    it 'craves vegan brains' do
      #zombie.vegetarian = true (refactored)
      #...
    end
  end
end
```

**Shared Examples**  

```ruby
# in spec/models/zombie_spec.rb
 describe Zombie do
   # zombie = Zombie.new
   it_behaves_like 'the undead'# refactored from zombie.pulse.should == false
end

# in spec/models/vampire_spec.rb
 describe Vampire do
   # vampire = Vampire.new
   it_behaves_like 'the undead' # refactored from vampire.pulse.should == false
end

#used to call shared examples
# in spec/support/shared_examples_for_undead.rb
shared_examples_for 'the undead' do
   it 'does not have a pulse' do
     subject.pulse.should == false # subject used to apply to what calls it
   end
end
```

**Test Tag**
Tags can be added to tests to differentiate what tests you want to run such as in the it block, set `focus: true` or `slow: true` so that they can be excluded when running.  Example:

`context 'with a smart zombie', focus: true do ...`

Running them from the command line with

`$ rspec --tag focus spec/lib/zombie_spec.rb`

to filter them out

`$ rspec --tag ~focus spec/lib/zombie_spec.rb`

## Mocking and Stubbing

Definitions:  
> * *Stub*
  * For replacing a method with code that returns a specifed result.
* *Mock*
  * A stub with an expectations that the method gets called.

`let(:zombie) { stub(:zombie, email: 'anything@example.org') }` stub format










***Note: Using should is deprecated, to use install `shoulda` gem***
