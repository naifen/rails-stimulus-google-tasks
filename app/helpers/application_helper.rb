# frozen_string_literal: true

module ApplicationHelper
  def notification_color flash_type
    case flash_type
      when "success"
        "is-success"   # Green
      when "error"
        "is-danger"    # Red
      when "alert"
        "is-warning"   # Yellow
      when "notice"
        "is-info"      # Blue
      else
        flash_type.to_s
    end
  end
end
