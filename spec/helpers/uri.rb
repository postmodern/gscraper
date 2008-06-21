require 'uri'

def url_should_be_valid(url)
  uri = URI(url)
  uri.scheme.should_not be_nil
  uri.host.should_not be_nil
  uri.path.should_not be_nil
end
