module PeopleHelper

  def message_links(people)
    people.map { |p| email_link(p)}
  end

  # Return a person's image link.
  # The default is to display the person's icon linked to the profile.
  def image_link(person, options = {})
    link = options[:link] || person
    version = options[:image] || :icon
    image_options = (options[:image_options] || {}).merge title: h(person.display_name), alt: h(person.display_name)
    link_options = (options[:link_options] || {}).merge title: h(person.display_name)
    content = image_tag(person.picture.send(version).url, image_options)
    # This is a hack needed for the way the designer handled rastered images (with a 'vcard' class).
    content += content_tag :span, h(person.display_name), :class => "fn" if options[:vcard]
    link_to(content, link, link_options)
  end

  # Link to a person (default is by name).
  def person_link(text, person = nil, html_options = nil)
    if person.nil?
      person = text
      text = person.display_name
    elsif person.is_a?(Hash)
      html_options = person
      person = text
      text = person.display_name
    end
    # We normally write link_to(..., person) for brevity, but that breaks
    # activities_helper_spec due to an RSpec bug.
    link_to(h(text), person, html_options)
  end


end
