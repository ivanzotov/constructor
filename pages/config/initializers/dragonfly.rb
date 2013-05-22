require 'dragonfly/rails/images'

app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)

app.configure do |c|
  c.url_format = '/images/:job/:basename.:format'
end