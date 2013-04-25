# encoding: utf-8

module ConstructorPages
  class Page < ActiveRecord::Base
    attr_accessible :active, :title, :url, :seo_title, :auto_url,
                    :parent_id, :content, :link, 
                    :in_menu, :in_map, 
                    :in_nav, :keywords, :description
                      
    has_many :images, :dependent => :destroy

    default_scope order(:lft)
    
    validates_presence_of :title
    
    before_save :url_prepare, :content_filter
    after_update :full_url_descendants_change
    
    before_update :full_url_change
    before_create :full_url_create
    
    acts_as_nested_set
    
    def self.children_of(page)
      Page.where(:parent_id => page).order(:lft)
    end
    
    private
    
    def full_url_change
      if parent_id
        self.full_url = '/' + Page.find(parent_id).self_and_ancestors.map {|c| c.url}.append(self.url).join('/')
      else
        self.full_url = '/' + self.url
      end
    end
    
    def full_url_create
      if self.parent.nil?
        self.full_url = '/' + self.url
      else
        self.full_url = self.parent.full_url + '/' + self.url         
      end
    end
    
    def full_url_descendants_change
      self.descendants.each { |c| c.save }
    end
    
    def content_filter
      self.content = self.content.force_encoding('utf-8')
    end
    
    def url_prepare
      if self.auto_url or self.url.empty?
        self.url = self.title.parameterize
      else
        self.url = self.url.parameterize
      end
    end
  end
end