module UserHelper
  # Get the Avatar to display for a given user
  def avatar_for(user, options = {})
    if user && user.image.present?
      options = { class: 'img-circle' }.merge(options)
      image_tag user.image, options
    else
      options = { class: 'fa fa-user fa-fw' }.merge(options)
      content_tag :span, options
    end
  end

  # Prettify a web address
  def pretty_url(url)
    url.gsub(%r{https?://(www\.)?}, '').chomp('/')
  end
end
