#!/usr/bin/env ruby

# Add the Rails app to the load path
require_relative 'config/environment'

puts "=" * 50
puts "USERS IN THE DATABASE"
puts "=" * 50

# Get all users
users = User.all

if users.any?
  puts "\n📊 SUMMARY:"
  total_users = users.count
  admin_users = users.where(role: 1).count
  regular_users = users.where(role: [0, nil]).count
  
  puts "Total Users: #{total_users}"
  puts "Admin Users: #{admin_users}"
  puts "Regular Users: #{regular_users}"
  
  puts "\n👤 REGULAR USERS:"
  puts "-" * 30
  regular_user_list = users.where(role: [0, nil])
  if regular_user_list.any?
    regular_user_list.each_with_index do |user, index|
      puts "#{index + 1}. #{user.email} (ID: #{user.id}, Role: #{user.role || 'nil (default user)'})"
    end
  else
    puts "No regular users found."
  end
  
  puts "\n⚡ ADMIN USERS:"
  puts "-" * 30
  admin_user_list = users.where(role: 1)
  if admin_user_list.any?
    admin_user_list.each_with_index do |user, index|
      puts "#{index + 1}. #{user.email} (ID: #{user.id}, Role: #{user.role})"
    end
  else
    puts "No admin users found."
  end
  
  puts "\n📅 EVENTS SUMMARY:"
  puts "-" * 30
  total_events = Event.count
  total_registrations = Registration.count
  
  puts "Total Events: #{total_events}"
  puts "Total Registrations: #{total_registrations}"
  
  if total_events > 0
    puts "\nEvents by user:"
    users.joins(:events).group(:email).count.each do |email, count|
      puts "  #{email}: #{count} event(s)"
    end
  end
  
else
  puts "No users found in the database."
end

puts "\n" + "=" * 50
puts "END OF REPORT"
puts "=" * 50
