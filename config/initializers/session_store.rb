# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_waterloonatic_session',
  :secret      => '75fefd2d9f210a27d9f59d5bacefa77211ba81f020d08e80cd39fea611115e3143198c9747552a98253e67fd606a13d0a71011a775c7beb9150e11e5c4ba979f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
