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

if File.exist?(ENV['HOME'] + '/.openyo') then
  load_setting
else
  puts 'config file does not exist'
end

case ARGV[0]
when 'yo' then 
  `curl -s -F api_ver=0.1 -F api_token=#{$api_token} -F username=#{ARGV[1]} #{$endpoint}/yo/`
when 'yoall' then 
  `curl -s -F api_ver=0.1 -F api_token=#{$api_token} #{$endpoint}/yoall/`
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
