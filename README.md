# [Gamification](https://zeus.ugent.be/game) [![Analytics](https://ga-beacon.appspot.com/UA-25444917-6/ZeusWPI/gamification/README.md?pixel)](https://github.com/igrigorik/ga-beacon) [![Code Climate](https://codeclimate.com/github/ZeusWPI/gamification/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/gamification) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/gamification/badge.svg?branch=master&service=github)](https://coveralls.io/github/ZeusWPI/gamification?branch=master) [![Build Status](https://travis-ci.org/ZeusWPI/gamification.png?branch=master)](https://travis-ci.org/ZeusWPI/gamification)

Gamification of Zeus member engagement (with GitHub integration)!

## Dev

This uses an old ruby version, use something like `rbenv` to manage it.

This project also uses `capistrano` to manage deployment, after doing `bundle install` also intall capistrano with `gem install capistrano`.

Now you can deploy to production with `cap production deploy`.

You can also do seeding and similar tasks with `cap production rails:rake:db:seed`.