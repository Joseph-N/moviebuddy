redis:      redis-server 
job_queue:  bundle exec sidekiq -d -L 'log/sidekiq.log' -q mailer,5 -q default -e production

