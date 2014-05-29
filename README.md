OneSignature.org
=========================

## Setup

First, install Ruby. Then,

```bash
gem install bundler
bundle install
bundle exec rake db:create db:seed
```

To run the project,

```bash
bundle exec ruby app.rb
```

### White House API
To use the White House petitions API, you need to specify your API key.

```bash
export WHITEHOUSE_API_SECRET='<your key here>'
```
