class PagesSpecHelper::NewActivityLogPage < SitePrism::Page
  set_url "activity_logs/new"

  element :started_at_field, ".new_activity_log #activity_log_started_at"
  element :ended_at_field, ".new_activity_log #activity_log_ended_at"
  element :label_field, ".new_activity_log #activity_log_label"
  element :submit_button, ".new_activity_log input[type='submit']"

  def fill_in_new_activity_log_form_with(attributes)
    if attributes[:started_at]
      started_at_field.set attributes[:started_at]
    end

    if attributes[:ended_at]
      ended_at_field.set attributes[:ended_at]
    end

    if attributes[:label]
      label_field.set attributes[:label]
    end
  end

  def submit_new_activity_log_form
    submit_button.click
  end
end
