# Update HAML so that it uses double quotes instead of single quotes around attribute values

Haml::Template.options = { :attr_wrapper => '"', :format => :html5, :ugly => false }
Sass::Plugin.options[:style] = :expanded   # :nested | :expanded | :compact | :compressed
