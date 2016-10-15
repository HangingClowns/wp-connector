module WpTerm
  extend ActiveSupport::Concern

  def update_term(json)
    return unless json.is_a?(Hash)

    self.class.mappable_wordpress_attributes.each do |wp_attribute|
      send("#{wp_attribute}=", json[wp_attribute])
    end

    self.wp_id        = json['ID']
    if json['parent']
      self.class.where(wp_id: json['parent']['ID']).first_or_create.update_wp_cache(json['parent'])
      self.parent_id = self.class.where(wp_id: json['parent']['ID']).first.id
    end

    save!
  end

  module ClassMethods

    def mappable_wordpress_attributes
      %w( name slug description count )
    end

    def wp_type
      self.to_s.underscore.pluralize
    end

  end
end
