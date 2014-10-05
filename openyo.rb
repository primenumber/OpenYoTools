#!/usr/bin/ruby

require 'json'

def save_setting
  File.write(ENV['HOME'] + '/.openyo', JSON.generate({
    'username' => $username,
    'api_token' => $api_token,
    'endpoint' => $endpoint
  }))
end

def load_setting
  json = JSON.parse(File.read(ENV['HOME'] + '/.openyo'))
  $username = json['username']
  $api_token = json['api_token']
  $endpoint = json['endpoint']
end

def show(response)
  json = JSON.parse(response)
  puts json['result']
end
if File.exist?(ENV['HOME'] + '/.openyo') then
  load_setting
else
  puts 'config file does not exist'
end

case ARGV[0]
when 'yo' then
  response = `curl -s -F api_ver=0.1 -F api_token=#{$api_token} -F username=#{ARGV[1]} #{$endpoint}/yo/`
  show(response)
when 'yoall' then 
  response = `curl -s -F api_ver=0.1 -F api_token=#{$api_token} #{$endpoint}/yoall/`
  show(response)
when 'friends_count' then 
  response = `curl -s "#{$endpoint}/friends_count/?api_ver=0.1&api_token=#{$api_token}"`
  json = JSON.parse(response)
  puts json['result']
when 'list_friends' then 
  response = `curl -s "#{$endpoint}/list_friends/?api_ver=0.1&api_token=#{$api_token}"`
  json = JSON.parse(response)
  puts json['result']
when 'create_user' then
  response = `curl -s -F api_ver=0.1 -F username=#{ARGV[1]} -F password=#{ARGV[2]} #{$endpoint}/config/create_user/`
  json = JSON.parse(response)
  $username = ARGV[1]
  $api_token = json['api_token']
  save_setting
when 'set' then
  case ARGV[1]
  when 'endpoint' then
    $endpoint = ARGV[2]
    save_setting
  end
end
