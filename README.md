[![Build Status](https://travis-ci.org/ephracis/appatite.svg?branch=master)](https://travis-ci.org/ephracis/appatite)
[![Code Climate](https://codeclimate.com/github/ephracis/appatite/badges/gpa.svg)](https://codeclimate.com/github/ephracis/appatite)
[![Test Coverage](https://codeclimate.com/github/ephracis/appatite/badges/coverage.svg)](https://codeclimate.com/github/ephracis/appatite/coverage)
[![Stories in progress](https://badge.waffle.io/ephracis/appatite.svg?label=in%20progress&title=in%20progress)](http://waffle.io/ephracis/appatite)
[![GitHub license](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://raw.githubusercontent.com/ephracis/appatite/master/LICENSE)
[![Issue Stats](http://www.issuestats.com/github/ephracis/appatite/badge/pr?style=flat)](http://www.issuestats.com/github/ephracis/appatite)
[![Issue Stats](http://www.issuestats.com/github/ephracis/appatite/badge/issue?style=flat)](http://www.issuestats.com/github/ephracis/appatite)

# Welcome to Appatite

This is the project for the [Appatite website](appatite.herokuapp.com).

## Get started

### Configuration
To enable signing in with Github or Gitlab you need to register an app
with those providers and save your ID and secret in the configuration file.

Register your application on [Github](https://github.com/settings/developers)
and [Gitlab](https://gitlab.com/profile/applications) to get your ID and secret.
Set callback URL to `http://<HOSTNAME>/users/auth/gitlab/callback`.

Then create the file `.env` and put in your tokens:

```bash
GITLAB_ID=...
GITLAB_SECRET=...
GITHUB_ID=...
GITHUB_SECRET=...
```

### Vagrant
The easiest way to get everything installed is by using [Vagrant](vagrantup.com).
Run the following command to spin up a dev machine running the app:

    vagrant up

You can now access the app on http://localhost:3000.

### Manually
Follow these steps to install the web app manually on a system.

#### Ruby
Install Ruby using [rvm](http://rvm.io) or rbenv. Recommended version is 2.3.1.

For RVM, do the following:

    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    curl -sSL https://get.rvm.io | bash -s stable --rails --ruby=2.3.1

#### Postgres
Install PostgreSQL by issuing the following commands:

##### macOS Sierra

    brew install postgres
    initdb /usr/local/var/postgres -E utf8
    gem install lunchy
    mkdir -p ~/Library/LaunchAgents
    cp /usr/local/Cellar/postgresql/<VERSION>/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/
    lunchy start postgres

##### Ubuntu 16.04

    apt-get -y install postgresql postgresql-contrib libpq-dev
    sudo su - postgres -c 'createuser $(whoami) -s;'

#### Bundler
Install Bundler for managing Ruby gems:

    gem install Bundler

#### Ruby gems
Continue to install all Ruby gem dependencies for the web app:

    bundle

#### Create database
Create the database

    bin/rails db:setup

## Run tests
Lint the code with the command `rubocop -aD`.

Run the test by issuing the command `bin/rails test`.

## Run local server
Run a local server on port 3000 by issuing the command `bin/rails server`.
