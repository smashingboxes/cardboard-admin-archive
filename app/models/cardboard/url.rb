module Cardboard
  class Url < ActiveRecord::Base
    belongs_to :urlable, polymorphic: true

    serialize :slugs_backup, Array
    serialize :meta_tags, Hash

    before_save :update_slugs_backup

    validates :path, presence: true
    validates :slug, uniqueness: { :case_sensitive => false, :scope => :path }, presence: true

    after_save :reload_routes

    # TODO: Should we use the homepage boolean?
    # before_save :update_homepage
    # def update_homepage
    #   return unless homepage_changed?
    #   self.class.where('id != ? AND homepage', self.id).update_all(homepage: false)
    # end

    def self.urlable_for(full_url, options = {})
      #TODO: refactor
      return nil unless full_url
      path, slug = self.path_and_slug(full_url)
      url_hash = {path: path, slug: slug}
      url_hash.merge!(urlable_type: options[:type]) if options[:type]

      page = self.where(url_hash).first

      if slug && page.nil?
        #use arel instead of LIKE/ILIKE
        page = self.where(path: path).where(self.arel_table[:slugs_backup].matches("% #{slug}\n%")).where(urlable_type: options[:type]).first
        page.using_slug_backup = true if page
      end

      page.try(:urlable)
    end

    def slug=(value)
      # the user can overwrite the auto generated slug
      self[:slug] = value.present? ? value.to_url : nil
    end

    def path=(value)
      return if value.nil?
      value = value.gsub(/\//, '')
      self[:path] = value.blank?? "/" : "/#{value}/"
    end

    def using_slug_backup?
      @using_slug_backup || false
    end

    def using_slug_backup=(value)
      @using_slug_backup = value
    end

    def slugs_backup=(value)
      if value.is_a?(String)
        self[:slugs_backup] = value.split(",").map(&:strip)
      else
        self[:slugs_backup] = value
      end
    end

    def to_s
      return "/" if slug.blank?
      "#{path}#{slug}/"
    end

  private

    def reload_routes
      DynamicRouter.reload
    end

    def self.path_and_slug(full_url)
      *path, slug = full_url.sub(/^\//, '').split('/')
      [path.blank? ? '/' : "/#{path.join('/')}/", slug]
    end


    def update_slugs_backup
      return nil if !self.slug_changed? || self.slug_was.nil?
      self.slugs_backup |= [self.slug_was] #Yes, that's a single pipe...
      self.slugs_backup = slugs_backup - [self.slug] #in case we are going back to a link that was in the backup
    end

  end
end
