namespace :all do
  desc 'Build gems into the pkg directory'
  task :build do
    sh 'rake build'

    %w{core pages}.each do |engine|
      sh "cd #{engine}"
      sh "gem build constructor-#{engine}.gemspec && mv constructor-#{engine}-#{ConstructorCore::VERSION}.gem ./../pkg/"
      sh "cd .."
    end
  end

  desc 'Push all gems to Rubygems'
  task :push do
     sh "for i in pkg/*#{ConstructorCore::VERSION}.gem; do gem push $i; done"
  end
end