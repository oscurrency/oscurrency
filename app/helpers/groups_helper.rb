module GroupsHelper
  
  def group_owner?(person,group)
    person == group.owner
  end
  
  # Return a group's image link.
  # The default is to display the group's icon linked to the profile.
  def group_image_link(group, options = {})
    link = options[:link] || group
    version = options[:image] || :icon
    image_options = (options[:image_options] || {}).merge title: h(group.name), alt: h(group.name)
    link_options = (options[:link_options] || {}).merge title: h(group.name)
    content = image_tag(group.picture.send(version).url, image_options)
    # This is a hack needed for the way the designer handled rastered images (with a 'vcard' class).
    content += content_tag :span, h(group.name), :class => "fn" if options[:vcard]
    link_to(content, link, link_options)
  end
  
  def group_link(group)
    link_to(h(group.name), group_path(group))
  end

  def delete_membership_link(person,group)
    membership = Membership.mem(person,group)
    if membership
      membership_path(membership)
    else
      "#"
    end
  end
end
