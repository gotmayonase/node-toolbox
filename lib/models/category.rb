class Category
  include Mongoid::Document
  
  field :name, type: String
  
  embeds_many :node_modules
  recursively_embeds_many
  
end