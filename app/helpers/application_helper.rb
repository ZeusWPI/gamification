module ApplicationHelper
  def alert_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      warning: 'alert-warning',
      notice: 'alert-info'
    }[flash_type.to_sym] || flash_type.to_s
  end

  def format_score(score)
    number_with_delimiter(score, delimiter: '&nbsp;'.html_safe)
  end

  def format_short_score(score)
    number_to_human(score, delimiter: '&thinsp;'.html_safe, separator: '.',
                           format: '%n&thinsp;%u'.html_safe,
                           units: { thousand: 'K', million: 'M', billion: 'G' })
  end

  def navbar_item(html, target)
    class_str = current_page?(target) ? 'active' : ''
    content_tag(:li, link_to(html, target), class: class_str)
  end
end
