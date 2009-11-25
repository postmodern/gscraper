require 'uri'

module Helpers
  def uri_should_be_valid(uri)
    uri.scheme.should_not be_nil
    uri.host.should_not be_nil
    uri.path.should_not be_nil
  end
end
