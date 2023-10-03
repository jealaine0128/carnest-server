# spec/support/simplecov.rb

# Include the 'simplecov' gem to generate code coverage reports
require 'simplecov'

# Start SimpleCov to begin code coverage analysis
SimpleCov.start do
  add_filter '/spec/'    # Exclude spec files themselves from coverage analysis
  add_filter '/config/'  # Exclude configuration files from coverage analysis
  add_filter '/db/'      # Exclude database configuration from coverage analysis

  # Group code coverage reports under the 'Specs' category for better organization
  add_group 'Specs', 'spec/'
end
