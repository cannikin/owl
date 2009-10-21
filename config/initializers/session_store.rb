# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_owl_session',
  :secret      => 'dcac28eab2e119bbcdd33224075543bbc7dea8cbc33b3f65b11a91e064b92be904fec6016328d569e72690e8ab5414994150c55184f0b4bcf152c93ebf2c83da'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
