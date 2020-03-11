class PagesSpecHelper::EditActivityLogPage < SitePrism::Page
  set_url "activity_logs{/activity_log_id}/edit"

  element :started_at_field, ".edit_activity_log #activity_log_started_at"
  element :ended_at_field, ".edit_activity_log #activity_log_ended_at"
  element :label_field, ".edit_activity_log #activity_log_label"
  element :submit_button, ".edit_activity_log input[type='submit']"

  def fill_in_edit_activity_log_form_with(attributes)
    if attributes.key?(:started_at)
      started_at_field.set attributes[:started_at]
    end

    if attributes.key?(:ended_at)
      ended_at_field.set attributes[:ended_at]
    end

    if attributes.key?(:label)
      label_field.set attributes[:label]
    end
  end

  def submit_edit_activity_log_form
    submit_button.click
  end
end
