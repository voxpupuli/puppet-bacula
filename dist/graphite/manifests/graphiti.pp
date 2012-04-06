class graphite::graphiti {

  # From https://github.com/paperlesspost/graphiti

  ## Dependencies
  # Ruby 1.9.2
  # Bundler (~>1.0)
  # Graphite (>=0.9.9)
  # Redis (>2)
  # Unicorn
  # RubyGems and various Gems (see Gemfile)
  # S3 Access (Credentials stored in seperate .yml file)

  ## Setup/Installation
  # Clone the repository
  # Make copies of the config/*.yml.example files for s3 and application
  # configuration.
  # Bundle: bundle install
  # Run: bundle exec unicorn -c config/unicorn.rb -E production -D
  # Generate the metrics list: bundle exec rake graphiti:metrics (In
  # order to make searching through your list of metrics fast, Graphiti
  # fetches and caches the full list in Redis. We put this in a rake
  # task that you can run in the background and set up on a cron.)
  # A Capfile and config/deploy.rb is provided for reference (though it
  # might work for you).

  package{ 'redis-server':
    ensure => present,
  }

  package{ [ 'bundler', 'unicorn']:
    provider => 'gem',
    ensure   => present,
  }



}
