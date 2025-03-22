#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid
bundle exec rails db:migrate RAILS_ENV=production
# bundle exec rails db:seed RAILS_ENV=production

exec "$@"
