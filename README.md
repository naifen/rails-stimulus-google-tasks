# Workspree

A unified work space for all your favorite apps without barriers.

- Ruby 2.5.1 & Rails 5.2.1

- Directory layout: `app/frontend` contains all frontend Javascripts and stylesheets. eg, `app/frontend/controllers` contains Stimulus.js controllers

- System dependencies:
  npm >= 5.6.0
  yarn >= 1.10.1

- Configuration

  1, Webpacker w/ Typescript support:

  `yarn add -D typescript ts-loader`

  Option 1: run `bundle exec rails webpacker:install:typescript`

  Option 2: manually add `.ts` to extensions section in `config/webpacker.yml`

  create `config/webpack/loaders/typescript.js`

  ```js
  module.exports = {
    test: /\.(ts|tsx)?(\.erb)?$/,
    use: [
      {
        loader: "ts-loader"
      }
    ]
  };
  ```

  and add to `config/webpack/environment.js`

  2, Editor integration:

  i, VS Code: TSLint, Prettier - Code formatter plugins

  ```json
  // ESLint + TSLint + Prettier settings
  "editor.formatOnSave": true,
  "prettier.disableLanguages": ["js", "ts"],
  "eslint.autoFixOnSave": true,
  "eslint.alwaysShowStatus": true,
  "eslint.packageManager": "yarn",
  "tslint.autoFixOnSave": true,
  "tslint.alwaysShowStatus": true,
  "tslint.packageManager": "yarn",
  "files.autoSave": "onFocusChange",

  "[javascript]": {
    "editor.tabSize": 2,
    "editor.formatOnSave": false
  },
  "[typescript]": {
    "editor.tabSize": 2,
    "editor.formatOnSave": false
  },
  ```

  ii, Vim: Syntastic + ruby cheker, Rubocop for Ruby

- Database initialization
  `rails db:create` creates Postgres DB

- Tests & specs setup

  add `rspec-rails, factory_bot_rails, database_cleaner, faker, capybara, shoulda-matchers, guard-rspec` gems to Gemfile and `bundle install`

  run `rails generate rspec:install`

  add configs to `spec/rails_helper.rb`

  ```ruby
  RSpec.configure do |config|
    ...

    # factory_bot_rails gem config
    config.include FactoryBot::Syntax::Methods

    # gem database_cleaner config
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end

    ...
  end

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
  ```

  create a `spec/factories` dir and add model factories there, eg
  `users.rb` Faker gem can be used directly in this file like

  ```ruby
  factory :rand_user, class: User do
    username { Faker::Internet.unique.username }
    email { Faker::Internet.unique.email }
    phone_number { Faker::PhoneNumber.unique.phone_number }
  end
  ```

  create a `spec/features` dir for capybara specs, eg:

  ```
  RSpec.feature "User authentication", :type => :feature do
    scenario "User tries to login" do
      ...
    end
  end
  ```

  remember to setup proper `.rspec` and `Guardfile`

  Finally, run `bundle exec guard`

  BTW, `bullet` gem config located at
  `config/environment/development.rb`

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- Roadmap

- Issues
  Development: byebug no echo in foreman with pry <https://github.com/pry/pry/issues/1290#issuecomment-314532050>
