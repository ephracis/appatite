Vagrant.configure(2) do |config|
  config.vm.box = 'bento/ubuntu-16.04'
  config.vm.network 'forwarded_port', guest: 3000, host: 3000
  config.vm.provision 'shell', inline: <<-SHELL
     set -e
     update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
     apt-get update
     apt-get install -y postgresql postgresql-contrib curl libpq-dev
     set +e
     su - postgres -c 'createuser vagrant -s; createuser root -s'
     set -e
     su - vagrant
     gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
     curl -sSL https://get.rvm.io | bash -s stable --rails --ruby=2.3.1
     source /usr/local/rvm/scripts/rvm
     cd /vagrant
     gem install bundle
     bundle install
     set +e
     bin/rails db:create
     set -e
     bin/rails db:migrate
     bin/rails server -b 0.0.0.0 -p 3000
  SHELL
end
