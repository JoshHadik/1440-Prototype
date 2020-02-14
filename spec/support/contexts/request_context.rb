RSpec.shared_context "request context", :shared_context => :metadata do

  #### Devise / Auth ####

  include Devise::Test::IntegrationHelpers

  define_method :sign_in_as do |factory, trait=nil|
    @resource = FactoryBot.create(factory, trait)
    sign_in @resource
  end

  define_method :reload_user do
    signed_in_user.reload
  end

  define_method :sign_in_as_user do |trait=nil|
    sign_in_as :user, trait
  end

  define_method :signed_in_resource do
    @resource
  end

  alias_method :signed_in_user, :signed_in_resource

  define_method :update_session_variables do
    get root_path
  end

  #### Simulations ####

  define_singleton_method :all_simulations do
    @simulations ||= {}
  end

  define_singleton_method :get_simulation do |label|
    all_simulations[label]
  end

  define_singleton_method :simulation do |label, &block|
    all_simulations[label] = lambda(&block)
  end

  define_method :simulate do |label, *args|
    block = self.class.get_simulation(label)
    self.instance_exec(*args, &block)
  end

  # Passes all simulations from parent class to subclass, otherwise you would not be able to use any simulations defined on the outer most level of a spec file within 'it' blocks that are nested under a different 'context' or 'describe' statement.
  define_singleton_method :inherited do |subclass|
    subclass.instance_variable_set(:@simulations, @simulations.dup)
  end

  #### Matchers ####

  RSpec::Matchers.define :match_attributes do |response_hash|
    match do |resource|
      response_hash.each do |key, value|
        expect(resource.send(key)).to eq(value)
      end
    end
    ## TODO -> Write Error Messages
  end

  RSpec::Matchers.define :update do |resource|
    match do |procedure|
      expect(&procedure).to change(resource.updated_at, :to_s)
    end

    chain :with do |**attributes|
      @attributes = attributes
    end

    supports_block_expectations

    ## TODO -> Write Error Messages
  end

  define_method(:expect_simulation) do |simulation_id, **args|
    block = proc { simulate(simulation_id, **args) }
    expect(&block)
  end

  define_method(:expect_simulation!) do |simulation_id, **args|
    expect(simulate(simulation_id, **args))
  end


  RSpec::Matchers.define :create_a_new do |resource_type|
    match do |block|
      expect(&block).to change(resource_type,:count).by(1)
    end

    match_when_negated do |block|
      expect(block).to_not change(resource_type,:count)
    end

    supports_block_expectations

    ## TODO -> Write Error Messages
  end

  # expect(:create_prompt).to create_a_new(Account).when_simulated(with: valid_attributes)

  # RSpec::Matchers.define_negated_matcher :update do |procedure|
  #   match do |resource|
  #     expect(&procedure).to_not change(resource.updated_at, :to_s)
  #   end
  # end

  # For some reason, using the before(:context) hook occasionally causes the database cleaner to fail (Failure/Error: DatabaseCleaner.clean - NoMethodError: undefined method `rollback' for nil:NilClass) Changing the strategy from :transaction to :truncation appears to fix this, though I'm not sure why.
  # before(:each) do
  #   DatabaseCleaner.strategy = :truncation
  # end
end
