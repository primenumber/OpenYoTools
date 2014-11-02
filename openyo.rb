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

if ARGV[0].nil?
  puts "Usage:"
  puts" #{File.basename(__FILE__)} yo USERNAME -- Yo to USERNAME"
  puts" #{File.basename(__FILE__)} yoall -- send Yo to all friends"
  puts" #{File.basename(__FILE__)} friend_count -- count friends"
  puts" #{File.basename(__FILE__)} list_friends -- show all friends"
  puts" #{File.basename(__FILE__)} history -- show recently Yo from friends"
  puts" #{File.basename(__FILE__)} create_user USERNAME PASSWORD -- create user"
  puts" #{File.basename(__FILE__)} set ENDPOINT -- set endpoint"
  exit(-1)
end

case ARGV[0]
when 'yo' then 
  if ARGV[1].nil?
    puts "Usage: #{File.basename(__FILE__)} yo USERNAME"
    exit(-1)
  end
  response = `curl -s -F api_ver=0.1 -F api_token=#{$api_token} -F username=#{ARGV[1]} #{$endpoint}/yo/`
  show(response)
when 'yoall' then 
  response = `curl -s -F api_ver=0.1 -F api_token=#{$api_token} #{$endpoint}/yoall/`
  show(response)
when 'friends_count' then 
  response = `curl -s "#{$endpoint}/friends_count/?api_ver=0.1&api_token=#{$api_token}"`
  show(response)
when 'list_friends' then 
  response = `curl -s "#{$endpoint}/list_friends/?api_ver=0.1&api_token=#{$api_token}"`
  show(response)
when 'history' then
  response = `curl -s "#{$endpoint}/history/?api_ver=0.1&api_token=#{$api_token}"`
  show(response)
when 'create_user' then
  if ARGV[1].nil?
    puts "Usage: #{File.basename(__FILE__)} create_user USERNAME PASSWORD"
    exit(-1)
  end
  response = `curl -s -F api_ver=0.1 -F username=#{ARGV[1]} -F password=#{ARGV[2]} #{$endpoint}/config/create_user/`
  json = JSON.parse(response)
  $username = ARGV[1]
  $api_token = json['api_token']
  save_setting
when 'set' then
  if ARGV[1].nil?
    puts "Usage: #{File.basename(__FILE__)} set endpoint ENDPOINT"
    exit(-1)
  end
  case ARGV[1]
  when 'endpoint' then
    $endpoint = ARGV[2]
    save_setting
  end
end
