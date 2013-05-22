require 'dragonfly/rails/images'

app = Dragonfly[:images]
app.configure_with(:imagemagick)
app.configure_with(:rails)

app.datastore = Dragonfly::DataStorage::S3DataStore.new({
    :bucket_name        => 'avgustklimat',
    :access_key_id      => 'AKIAIGSQM22DEELECHJQ',
    :secret_access_key  => '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'
})

app.configure do |c|
  c.url_format = '/images/:job/:basename.:format'
end