#!/usr/bin/env ruby

require 'octokit'

variables = %w{GH_USER PASSWORD ACCESS_TOKEN ORG_NAME}
missing = variables.find_all { |v| ENV[v] == nil }
unless missing.empty?
  raise "The following environment variables are missing and are needed to run this script: #{missing.join(', ')}."
end

Octokit.auto_paginate = true
client = Octokit::Client.new \
  :login    => ENV['GH_USER'],
  :password => ENV['PASSWORD']
client = Octokit::Client.new(:access_token => ENV['ACCESS_TOKEN'])
user = client.user
user.login
repos = client.org_repos(ENV['ORG_NAME'], {:type => 'all'}).collect(&:ssh_url).join("\n")
puts repos
