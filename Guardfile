extensions = %w(pages core)

guard 'rspec', :spec_paths => extensions.map{|e| "#{e}/spec"}, :cli => (['~/.rspec', '.rspec'].map{|f| File.read(File.expand_path(f)).split("\n").join(' ') if File.exists?(File.expand_path(f))}.join(' ')) do
  extensions.each do |extension|
    watch(%r{^#{extension}/spec/.+_spec\.rb$})
    watch(%r{^#{extension}/app/(.+)\.rb$})                           { |m| "#{extension}/spec/#{m[1]}_spec.rb" }
    watch(%r{^#{extension}/lib/constructor_#{extension}/(.+)\.rb$})                           { |m| "#{extension}/spec/lib/constructor_#{extension}/#{m[1]}_spec.rb" }
    watch(%r{^#{extension}/app/controllers/constructor_#{extension}/(.+)_(controller)\.rb$})  { |m| "#{extension}/spec/features/constructor_#{extension}/#{m[1]}_spec.rb" }
    watch(%r{^#{extension}/spec/support/(.+)\.rb$})                  { "#{extension}/spec" }
    watch("#{extension}/spec/spec_helper.rb")                        { "#{extension}/spec" }
    # Capybara request specs
    watch(%r{^#{extension}/app/views/(.+)/.*\.(erb|haml)$})          { |m| "#{extension}/spec/requests/#{m[1]}_spec.rb" }
  end
end

