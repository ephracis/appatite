[![Build Status](https://travis-ci.org/ephracis/appatite.svg?branch=master)](https://travis-ci.org/ephracis/appatite)
[![Code Climate](https://codeclimate.com/github/ephracis/appatite/badges/gpa.svg)](https://codeclimate.com/github/ephracis/appatite)
[![Test Coverage](https://codeclimate.com/github/ephracis/appatite/badges/coverage.svg)](https://codeclimate.com/github/ephracis/appatite/coverage)
[![GitHub license](https://img.shields.io/badge/license-GPLv3-blue.svg)](https://raw.githubusercontent.com/ephracis/appatite/master/LICENSE)
[![Issue Stats](http://www.issuestats.com/github/ephracis/appatite/badge/pr?style=flat)](http://www.issuestats.com/github/ephracis/appatite)
[![Issue Stats](http://www.issuestats.com/github/ephracis/appatite/badge/issue?style=flat)](http://www.issuestats.com/github/ephracis/appatite)
[![Libraries.io for GitHub](https://img.shields.io/librariesio/github/ephracis/appatite.svg?maxAge=2592000)](https://libraries.io/github/ephracis/appatite)
[![Issues in progress](https://badge.waffle.io/ephracis/appatite.svg?label=in%20progress&title=issues%20in%20progress)](http://waffle.io/ephracis/appatite)

# Welcome to Appatite

This is the project for the [Appatite website](http://appatite.herokuapp.com).

## Get started

If you want to run Appatite on your own machine, follow these instructions.

### Vagrant
The easiest way to get everything installed is by using [Vagrant](vagrantup.com).
Run the following command to spin up a dev machine running the app:

    vagrant up

You can now access the machine:

    vagrant ssh
    cd /vagrant

Run the tests:

```bash
bin/rails rubocop  # lint ruby code
bin/rails spec     # test ruby code
bin/rails teaspoon # test javascript code
```

Start the server:

    bin/rails server -b 0.0.0.0

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

    gem install bundler

#### Ruby gems
Continue to install all Ruby gem dependencies for the web app:

    bundle

#### Create database
Create the database

    bin/rails db:setup

That's it! You can now run the tests and start the server just as described
above in the *Vagrant* section.

### Configuration
#### Authentication
To enable signing in with GitHub or GitLab you need to register an app
with those providers.

Register your application on [Github](https://github.com/settings/developers)
and [Gitlab](https://gitlab.com/profile/applications) to get your ID and secret.
Set callback URL to `https://<HOSTNAME>/users/auth/gitlab/callback`.

Enter the credentials on the settings page in the admin area.

#### Crash reports
If you want to use Sentry to track app crashes and errors you need to add a line
like the following to the file `.env`:

```
SENTRY_DSN=https://XXXX:XXXX@sentry.io/XXXX
```

Restart the app after changing this file.
