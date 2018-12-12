# frozen_string_literal: true

module ApplicationHelper
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def image_link_to(url: "", link_options: {}, image_src: "", image_options: {})
    link_to url, link_options do
      image_tag image_src, image_options
    end
  end

  def text_field_content_for(
    form_object: nil,
    control_class: "control has-icons-left has-icons-right",
    left_icon_class: "fab fa-apple"
  )
    tag.div class: control_class do
      concat yield form_object

      concat tag.span (tag.i class: left_icon_class), class: "icon is-small is-left"
      concat tag.span class: "validation-indicator icon is-small is-right"
      concat tag.p class: "help is-success"
      concat tag.p class: "help is-danger"
    end
  end

  def notification_color(flash_type)
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
        "is-#{flash_type.to_s}"
    end
  end
end
