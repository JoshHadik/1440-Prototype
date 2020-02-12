class PagesSpecHelper::RootPage < SitePrism::Page
  set_url "/"

  element :delete_account_link, "#primary_nav #delete_account_link"

  def delete_account
    delete_account_link.click
  end
end
