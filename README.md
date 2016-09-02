[![Build Status](https://travis-ci.org/ephracis/appatite.svg?branch=master)](https://travis-ci.org/ephracis/appatite)
[![Code Climate](https://codeclimate.com/github/ephracis/appatite/badges/gpa.svg)](https://codeclimate.com/github/ephracis/appatite)
[![Test Coverage](https://codeclimate.com/github/ephracis/appatite/badges/coverage.svg)](https://codeclimate.com/github/ephracis/appatite/coverage)
[![GitHub license](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://raw.githubusercontent.com/ephracis/appatite/master/LICENSE)

# Welcome to Appatite

This is the project for the Appatite website.

## Prerequisites
- Ruby (use [rvm](http://rvm.io))
- Postgres
  - `brew install postgres`
  - `initdb /usr/local/var/postgres -E utf8`
  - `gem install lunchy`
  - `mkdir -p ~/Library/LaunchAgents`
  - `cp /usr/local/Cellar/postgresql/<VERSION>/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/`
  - `luncy start postgres`

## Getting started
Install bundler with `gem install bundler` and then install all depencencies
by running `bundle`.

Create the database using the command `bin/rails db:setup`.

## Configuration
To enable signing in with Github or Gitlab you need to register an app
with those providers and save your ID and secret in the configuration file.

Register your application to get your ID and secret:
- [Github](https://github.com/settings/developers)
  - Callback URL: http://example.com/users/auth/gitlab/callback
- [Gitlab](https://gitlab.com/profile/applications)
  - Callback URL: http://example.com/users/auth/github/callback

Then create the file `.env` and put in your tokens:

```bash
GITLAB_ID=...
GITLAB_SECRET=...
GITHUB_ID=...
GITHUB_SECRET=...
```

## Run tests
Lint the code with the command `rubocop`.

Run the test by issuing the command `bin/rails test`.

## Run local server
Run a local server on port 3000 by issuing the command `bin/rails server`.
