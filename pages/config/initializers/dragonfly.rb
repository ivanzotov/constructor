require 'dragonfly/rails/images'

app = Dragonfly[:images]
app.configure do |c|
  c.url_format = '/images/:job/:basename.:format'
end