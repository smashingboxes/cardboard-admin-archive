if Cardboard.user_class
  Cardboard.user_class.class_eval do

    # has_many :cardboard_blog_posts, :class_name => "CardboardBlog::Post", :foreign_key => "user_id"

    # User class should overwrite these methods with his own
    # ['pages', 'settings'].each do |m|
    #   method = "can_manage_cardboard_#{m}?"
    #   unless method_defined?(method.to_sym)
    #     define_method method do
    #       true
    #     end
    #   end
    # end
    unless method_defined?(:can_manage_cardboard_pages?)
      def can_manage_cardboard_pages?
        true
      end
    end
    unless method_defined?(:can_manage_cardboard_settings?)
      def can_manage_cardboard_settings?
        true
      end
    end
    unless method_defined?(:can_manage_cardboard_resource?)
      def can_manage_cardboard_resource?(resource)
        true
      end
    end

  end
end
