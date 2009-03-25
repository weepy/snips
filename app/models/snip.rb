class Snip < ActiveRecord::Base
  gem 'RedCloth', '<4' # v4 no longer supports both markdown + textile
  
  before_save :nilify_blank_layout
  validates_uniqueness_of :path
  
  def page?
    !layout.blank?
  end
  
  def absolute_path
    "/#{path}"
  end
  
  def render admin=true
     
    output = render_markup.gsub /\{\{[\w_\-\/]+\}\}/ do |path|
     
      path = path.gsub /[\{\}]/, ""
      
      begin
        snip = Snip.find :first, :conditions => ["path = ?", path ]
        snip.render(admin)
      rescue => e
        #raise e
        admin ? "<div class='snip_missing snip' name=' '><a href='/snips/new?snip[path]=#{path}' >No snip: '#{path}'. Create</a></div>" : ""
      end
    end
  
    admin ? "<div class=snip snip=#{id} name='#{path}'><div>#{output}</div></div>" : output
  end
  require "erb"
  
  def render_markup
    case render_type
      when 'redcloth'
        RedCloth.new(raw_text).to_html
      when 'haml'
        require 'haml'
        Haml::Engine.new(raw_text).to_html
      when 'text/html', nil
        raw_text
      when 'erb'
        ERB.new(raw_text).result
      else
        raise "Snips Error - no such render type : #{render_type}"
    end
  end
  
  protected

    
  def nilify_blank_layout
    self.layout=nil if layout.blank?
  end
  
end
