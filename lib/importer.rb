require "rubygems"
require "bundler/setup"

require 'nokogiri'
require 'mongoid'
require 'open-uri'

require 'models/category'
require 'models/node_module'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db("node-toolbox")
end

class Importer
  
  attr_accessor :url, :doc
  
  def self.import!
    importer = self.new('https://github.com/joyent/node/wiki/modules')
    importer.import!
  end
  
  def initialize url
    @url = url
    @doc = Nokogiri::HTML(open(@url))
  end
  
  def import!
    import_from_github
    update_module_info
  end
  
  private
  
  def update_module_info
    puts "Updating Module Info from Github API"
    Category.all.each do |category|
      if (children = category.child_categories).any?
        children.each do |child|
          update_modules_for_category(child)
        end
      else
        update_modules_for_category(category)
      end
    end
    puts
  end
  
  def update_modules_for_category category
    category.node_modules.each do |node_module|  
      node_module.update_info
      node_module.active ? print('.') : print('I')
      # GitHub API only allows 60 requests per minute, so sleep to avoid hitting the cap
      sleep 1
    end
  end
  
  def import_from_github
    puts "Importing Modules and Categories from Github Wiki..."
    container = @doc.css('#template')
    container.children.each do |node|
      case node.name
      when 'h3'
        print '.'
        @last_cat = @last_parent_cat = Category.find_or_create_by(name: node.inner_text)
      when 'h4'
        print '.'
        @last_cat = @last_parent_cat.child_categories.find_or_create_by(name: node.inner_text)
      when 'ul'
        import_from_ul(node)
      end
    end
    puts
  end
  
  def import_from_ul node
    node.children.each do |li|
      link = li.css('a')[0]
      next unless link
      name, url = link.inner_text, link.attributes['href'].value
      next if url =~ /#/
      print '.'
      @last_cat.node_modules.find_or_create_by(name: name, url: url)
    end
  end
  
end