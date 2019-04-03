puts 'Seeding school_strings (idempotent)'

after 'development:schools' do
  sv = School.find_by(name: 'SV.CO')

  # Header links
  sv.school_links.where(kind: 'header', title: 'About').first_or_create!(url: 'http://sv.localhost/about')
  sv.school_links.where(kind: 'header', title: 'Library').first_or_create!(url: 'http://school.sv.localhost/library')
  sv.school_links.where(kind: 'header', title: 'Blog').first_or_create!(url: 'https://blog.sv.co')

  # Footer links
  sv.school_links.where(kind: 'footer', title: 'About').first_or_create!(url: 'http://sv.localhost/about')
  sv.school_links.where(kind: 'footer', title: 'Blog').first_or_create!(url: 'https://blog.sv.co')
  sv.school_links.where(kind: 'footer', title: 'Media Kit').first_or_create!(url: 'http://sv.localhost/about/media-kit')
  sv.school_links.where(kind: 'footer', title: 'Library').first_or_create!(url: 'http://school.sv.localhost/library')
  sv.school_links.where(kind: 'footer', title: 'Changelog').first_or_create!(url: 'http://school.sv.localhost/changelog')
  sv.school_links.where(kind: 'footer', title: 'Contact Us').first_or_create!(url: 'http://sv.localhost/about/contact')

  # Social links
  sv.school_links.where(kind: 'social', title: 'Facebook').first_or_create!(url: 'https://www.facebook.com/svdotco')
  sv.school_links.where(kind: 'social', title: 'Twitter').first_or_create!(url: 'https://twitter.com/svdotco')
  sv.school_links.where(kind: 'social', title: 'YouTube').first_or_create!(url: 'https://www.youtube.com/c/svdotco')
  sv.school_links.where(kind: 'social', title: 'Instagram').first_or_create!(url: 'https://www.instagram.com/svdotco')
end