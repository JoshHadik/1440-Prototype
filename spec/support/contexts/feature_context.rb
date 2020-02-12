RSpec.shared_context "feature context", :shared_context => :metadata do
  include DeviseSpecHelper
  include PagesSpecHelper

  include Capybara::DSL
  include Rails.application.routes.url_helpers

  define_method :content_for do |content_symbol|
    content[content_symbol] or raise_missing_alert(content_symbol)
  end

  define_method :then_i_should_see do |content|
    expect(page).to have_content content
  end

  alias_method :and_i_should_see, :then_i_should_see

  define_method :then_i_should_see_content_for do |content_symbol|
    then_i_should_see content_for content_symbol
  end

  alias_method :and_i_should_see_content_for, :then_i_should_see_content_for

  define_method :raise_missing_alert do |alert_name|
    raise "No alert named #{alert_name} is defined. Existing alerts are #{alerts.keys.join(", ")}."
  end
end
