module CodersHelper
  def avatar(coder, size: '45', name: false)
    link_to coder, class: 'avatar' do
      concat image_tag coder.avatar_url, alt: coder.github_name, size: size
      concat coder.github_name if name
    end
  end
end
