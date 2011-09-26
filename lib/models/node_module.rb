class NodeModule
  include Mongoid::Document
  
  field :name, type: String
  field :forks, type: Integer
  field :watchers, type: Integer
  field :active, type: Boolean
  field :description, type: String
  field :pushed_at, type: DateTime
  
  embedded_in :category
  
  def update_info
    begin
      api_url = url.gsub('https://github.com/','http://github.com/api/v2/json/repos/show/')
      info = JSON::parse(open(api_url).read)['repository']
      self.forks = info["forks"]
      self.watchers = info["watchers"]
      self.description = info["description"]
      self.pushed_at = info["pushed_at"]
      self.active = true
    rescue
      self.active = false
    ensure
      self.save
    end
  end
end