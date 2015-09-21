# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

# Although this is not needed for an api-only application, rails4 
# requires secret_key_base or secret_token to be defined, otherwise an 
# error is raised.
# Using secret_token for rails3 compatibility. Change to secret_key_base
# to avoid deprecation warning.
# Can be safely removed in a rails3 api-only application.
ImageDimensionScalerApi::Application.config.secret_token = 'e462740f9e7c2c8ded3ca11a2f60e10036d5fde4efe81237aeef9d3751e7fd2e8d27c0ba65cb5dd0b19fa0505cf0c16505bb77dd0dcd9b90939f22ca6de1e09d'
