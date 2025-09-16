# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Create test users
regular_user = User.find_or_create_by!(email: 'user@test.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = 0 # regular user
end

admin_user = User.find_or_create_by!(email: 'admin@test.com') do |user|
  user.password = 'admin123'
  user.password_confirmation = 'admin123'
  user.role = 1 # admin
end

puts "✅ Created test users:"
puts "   Regular User: user@test.com (password: password123)"
puts "   Admin User: admin@test.com (password: admin123)"

# Create sample events
events_data = [
  {
    name: "Tech Conference 2025",
    date: 1.month.from_now,
    location: "Convention Center, New York",
    description: "Join industry leaders for the latest in technology trends, networking opportunities, and hands-on workshops."
  },
  {
    name: "Music Festival",
    date: 2.months.from_now,
    location: "Central Park, New York",
    description: "Three days of incredible music featuring local and international artists across multiple genres."
  },
  {
    name: "Startup Pitch Night",
    date: 3.weeks.from_now,
    location: "Innovation Hub, Silicon Valley",
    description: "Watch promising startups pitch their ideas to a panel of investors and industry experts."
  },
  {
    name: "Art Exhibition Opening",
    date: 10.days.from_now,
    location: "Modern Art Gallery, Chicago",
    description: "Discover contemporary works from emerging artists in this exclusive gallery opening."
  },
  {
    name: "Food & Wine Tasting",
    date: 5.days.from_now,
    location: "Downtown Restaurant, San Francisco",
    description: "Sample exquisite wines paired with gourmet dishes prepared by renowned chefs."
  }
]

events_data.each_with_index do |event_data, index|
  user = index.even? ? regular_user : admin_user
  event = user.events.find_or_create_by!(name: event_data[:name]) do |e|
    e.date = event_data[:date]
    e.location = event_data[:location]
    e.description = event_data[:description]
  end
  
  # Create sample registrations for each event
  (1..rand(3..8)).each do |i|
    event.registrations.find_or_create_by!(attendee_email: "attendee#{i}@#{event.name.downcase.gsub(/[^a-z0-9]/, '')}event.com") do |reg|
      reg.attendee_name = "#{['John', 'Jane', 'Mike', 'Sarah', 'David', 'Lisa', 'Tom', 'Emma'].sample} #{['Smith', 'Johnson', 'Brown', 'Davis', 'Wilson', 'Moore', 'Taylor', 'Anderson'].sample}"
    end
  end
end

puts "✅ Created #{Event.count} events with #{Registration.count} total registrations"
puts "🎉 Database seeding completed!"

puts "\n📋 Summary:"
puts "   Total Users: #{User.count}"
puts "   Total Events: #{Event.count}"
puts "   Total Registrations: #{Registration.count}"
puts "   Events by Regular Users: #{regular_user.events.count}"
puts "   Events by Admin Users: #{admin_user.events.count}"
