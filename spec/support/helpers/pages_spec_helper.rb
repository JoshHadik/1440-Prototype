module PagesSpecHelper
  attr_accessor :last_loaded_page

  def pages
    @pages ||= get_pages
  end

  def load_page(page, with: {})
    with.blank? ? pages[page].load : pages[page].load(with)
    @last_loaded_page = pages[page]
  end

  def current_page
    @last_loaded_page
  end

  private

  def get_pages
    Dir[Rails.root.join("spec/support/pages/**/*_page.rb")]
    .inject({}) do |pages, path|
      page_name = File.basename(path, ".*")

      pages.tap do |h|
        pages[page_name.to_sym] = PagesSpecHelper.const_get(page_name.camelize).new
      end
    end
  end
end
