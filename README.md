# Constructor CMS

Content management system on Ruby on Rails

## Screenshots
![Screenshot structure](https://s3-eu-west-1.amazonaws.com/constructorcms/screenshot_structure.png)

## Installation

### Add to Gemfile

    gem 'constructor-cms'    

### Install

    bundle install

### Migrate
    
    rake constructor_core:install:migrations
    rake constructor_pages:install:migrations
    
    rake db:migrate

## Copyright
  Copyright © 2012—2013 Ivan Zotov. See [LICENSE][] for details.
  
  [license]: LICENSE.md

