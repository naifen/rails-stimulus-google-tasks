# Workspree

A unified work space for all your favorite apps without barriers.

- Ruby version
  2.5.1

- Rails version
  5.2.1

- System dependencies
  npm >= 5.6.0
  yarn >= 1.10.1

- Configuration

  Webpacker w/ Typescript support:

  `yarn add -D typescript ts-loader`

  Option 1: run `bundle exec rails webpacker:install:typescript`

  Option 2: manually add `.ts` to extensions section in `config/webpacker.yml`

  create ``config/webpack/loaders/typescript.js

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

  Editor integration:

  VS Code: TSLint, Prettier - Code formatter plugins

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

  Vim: Syntastic + ruby cheker, Rubocop for Ruby

- Database initialization
  `rails db:create` creates Postgres DB

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- Roadmap
