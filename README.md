# rails-tutorial-template

Just the best parts from Michael Hartl's wonderful [book](https://www.railstutorial.org/book).

Learn how to [deploy it into production](http://www.libertyseeds.ca/2015/03/31/Deploying-the-Rails-Tutorial-Sample-App/).

# Download

```
git clone https://github.com/RaphaelDeLaGhetto/rails-tutorial-template.git
```

# Install dependencies

```
cd rails-tutorial-template
bundle install
npm install
```

# Set up database

```
rake db:setup
```

## Test data

```
rake db:seed
```

# Configure

`config/application.yml` is where [figaro](https://github.com/laserlemon/figaro) stores all your secret configuration details, so you need to create it manually:

```
vim config/application.yml
```

Paste this and save:

```
# General
app_name: 'rails_tutorial_template'
app_title: 'Ruby on Rails Tutorial Sample App'

# Email
default_from: 'noreply@example.com'
#gmail_username: "noreply@example.com"
#gmail_password: "secretp@ssword"

# Production
#host: "example.com"
#secret_key_base: "SomeRakeSecretHexKey"
#provider_database_password: 'secretp@ssword'
```

# Run server

```
rails s
```

# Rails test

```
rake
```

# React test

```
npm test
```

# License

MIT
