require 'nokogiri'
require 'httpclient'
require 'clamp'
require 'highline'

class ICloudReader
  PRINCIPAL_URL_XML = 
  %Q{<A:propfind xmlns:A='DAV:'>
    <A:prop>
    <A:current-user-principal/>
    </A:prop>
    </A:propfind>
  }
  
  CALENDARS_XML =
  %Q{  <A:propfind xmlns:A='DAV:'>
    <A:prop>
    <A:displayname/>
    </A:prop>
    </A:propfind>
  }    
  
  attr_reader :calendars, :user_id
  
  def initialize(options = {})
    @server_number = options[:server_number] || 1
    @client = HTTPClient.new
    @username = options[:username]
    @password = options[:password]
    @user_id = load_user_id
    @calendars = load_calendars
  end
  
  def base_calendars_url
    "https://p0#{@server_number}-caldav.icloud.com"
  end
  
  def base_contacts_url
    "https://p0#{@server_number}-contacts.icloud.com"
  end  
  
  def calendars_url
    URI.join(base_calendars_url, "#{user_id}/calendars/").to_s 
  end
  
  def contacts_url
    URI.join(base_contacts_url, "#{user_id}/carddavhome/card/").to_s
  end
  
  def load_user_id
    document = xml_request(base_calendars_url, PRINCIPAL_URL_XML)
    document.search("current-user-principal href").first.text.split("/")[1]    
  end
  
  def load_calendars   
    document = xml_request(calendars_url, CALENDARS_XML)  
    calendars = {}

    document.search("response").each do |response|
      path = response.search("href").first.text
      url = URI.join(calendars_url, path)
      displayName = response.search("displayname").first
      calendars[displayName.text] = url.to_s if displayName
    end
  
    calendars
  end
  
  private
  
  def xml_request(*args)
    response = request(*args)
    raise "Authentication failed! Check your username and password! #{response.code}" if response.code == 401    
    raise "Invalid Response! I have no idea how to handle this... #{response.code}" unless response.code == 207
    Nokogiri::XML(response.body)
  end
  
  def request(url, xml)
    domain = url
    @client.set_auth(domain, @username, @password)
    result = @client.request("PROPFIND", url, nil, xml, headers)
    result
  end
  
  def headers
    {
      "Depth" => "1",
      "Content-Type" => "text/xml; charset='UTF-8'"
    }    
  end
  
end

class ICloudReaderCommand < Clamp::Command
  option ["-s", "--server-number"], "SERVER_NUMBER", "the number of the server to use", :default_value => "8"
  
  def reader
    unless @reader
      username = ask_for_username
      password = ask_for_password
      @reader = ICloudReader.new(:server_number => server_number, :username => username, :password => password)
    end
    @reader
  end
  
  def asker
    HighLine.new
  end
  
  def ask_for_username
    asker.ask("Username: ")
  end
  
  def ask_for_password
    asker.ask("Password (will be masked with x's): ")  { |q| q.echo = "x" }   
  end
  
  subcommand "calendars", "list the calendars and their URLs (as YAML)" do
    def execute
      puts reader.calendars.to_yaml      
    end    
  end
  
  subcommand "contacts", "get your CardDAV url" do
    def execute
      puts reader.contacts_url
    end    
  end
  
end


