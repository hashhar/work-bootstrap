require 'octokit'

Octokit.auto_paginate = true
client = Octokit::Client.new \
  :login    => '%user%',
  :password => '%password%'
client = Octokit::Client.new(:access_token => '%access_token%')
user = client.user
user.login
repos = client.org_repos('%org_name%', {:type => 'all'}).collect(&:ssh_url).join("\n")
puts repos

