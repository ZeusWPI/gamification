module CodersHelper
  def avatar(coder, size: '45')
    img = image_tag coder.avatar_url,
                    alt: coder.github_name, size: size
    link_to img, coder, class: 'avatar'
  end
end
