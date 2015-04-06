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
default_from: 'noreply@example.com'
```

# Run server

```
rails s
```

# Test

```
rake
```

# License

MIT
