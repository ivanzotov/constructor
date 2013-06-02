Rails.application.class.configure do
  config.assets.precompile += ['ckeditor/*']
  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
  config.assets.precompile += %w( .svg .eot .woff .ttf )
end