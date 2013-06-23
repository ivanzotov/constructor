namespace :all do
  desc 'Build gems into the pkg directory'
  task :build do
    sh 'rake build'

    %w{core pages}.each do |engine|
      sh "gem build #{engine}/constructor-#{engine}.gemspec && mv constructor-#{engine}-#{ConstructorCore::VERSION}.gem pkg/"
    end
  end

  desc 'Push all gems to Rubygems'
  task :push do
     sh 'for i in pkg/*; do gem push $i; done'
  end
end