# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bookkeeper_session',
  :secret      => 'c776d5229831573c9565f799eb745a58611f3c92ab2627e31b125e1223b9358485f8c2290a32b11084a7e19e2d894504f40379321c7fcde23f2b2188fbb54916'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
ActionController::Base.session_store = :active_record_store
