# [Gamification](https://zeus.ugent.be/game) [![Analytics](https://ga-beacon.appspot.com/UA-25444917-6/ZeusWPI/gamification/README.md?pixel)](https://github.com/igrigorik/ga-beacon) [![Code Climate](https://codeclimate.com/github/ZeusWPI/gamification/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/gamification) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/gamification/badge.svg?branch=master&service=github)](https://coveralls.io/github/ZeusWPI/gamification?branch=master) [![Build Status](https://travis-ci.org/ZeusWPI/gamification.png?branch=master)](https://travis-ci.org/ZeusWPI/gamification)

Gamification of Zeus member engagement (with GitHub integration)!

## Setup

This uses an old ruby version, use something like `rbenv`, or preferable `asdf` to manage it.

Set your [GitHub API token](https://github.com/settings/tokens) in `.env`:
```bash
GITHUB_TOKEN=yourtokenhere
```

Run `rails db:seed`


## Deployment

This project also uses `capistrano` to manage deployment, after doing `bundle install` also intall capistrano with `gem install capistrano`.

Now you can deploy to production with `cap production deploy`.

You can also do seeding and similar tasks with `cap production rails:rake:db:seed`.

## UTF-8 issues

Make sure the database supports utf8, a migration has been added to set some settings. For others root acces is required.

Set these global variables with `mysql -u root` as well:

```cnf
SET GLOBAL innodb_file_format=Barracuda;
SET GLOBAL innodb_file_per_table=ON;
SET GLOBAL innodb_large_prefix=1;
```

**[source](https://mensfeld.pl/2016/06/ruby-on-rails-mysql2error-incorrect-string-value-and-specified-key-was-too-long/)**

## Fixing a missed webhook

If gamification misses the webhook that a repository was created, it will never add it.

Fix this by adding it manually in the console:

```ruby
Repository.create_or_update({'name' => 'g2-backend', 'html_url' => 'https://github.com/zeuswpi/g2-backend', 'clone_url' => 'https://github.com/ZeusWPI/g2-backend.git'})
```

if necessary, first delete the repository in both the console and the actual repository on the filesystem
