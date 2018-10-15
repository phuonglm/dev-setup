# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version '>= 1.9.1'
# workaround for vagrant < 2.0
# Vagrant::DEFAULT_SERVER_URL.replace('https://vagrantcloud.com')

# not supposed to be edited by normal users
Vagrant.configure('2') do |config|
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :machine
  end
end
