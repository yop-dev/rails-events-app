#!/usr/bin/env bash
# exit on error
set -o errexit

# Install gems
bundle install

# Precompile assets (Rails 8 with Propshaft)
bundle exec rails assets:precompile

# Run database migrations
bundle exec rails db:migrate
