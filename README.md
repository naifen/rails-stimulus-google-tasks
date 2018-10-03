# Workspree

A unified work space for all your favorite apps without barriers.

* Ruby version
2.5.1

* Rails version
5.2.1

* System dependencies
npm >= 5.6.0
yarn >= 1.10.1

* Configuration
Webpacker w/ Typescript support:
``yarn add -D typescript ts-loader``
add ``.ts`` to extensions section in ``config/webpacker.yml``
add
```js
environment.loaders.append('typescript', {
  test: /\.ts?$/,
  use: 'ts-loader'
})
```
to ``config/webpack/development.js``

* Database initialization
``rails db:create`` creates Postgres DB

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Roadmap
