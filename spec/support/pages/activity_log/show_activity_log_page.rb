class PagesSpecHelper::ShowActivityLogPage < SitePrism::Page
  set_url "activity_logs{/activity_log_id}"

  element :delete_activity_log_link, "#delete_activity_log"

  def delete_activity_log
    delete_activity_log_link.click
  end
end
