class Offer < ActiveRecord::Base
  include ActivityLogger
  include AnnouncementBase
  include HasPhotos

  module Scopes
    def active
      where("available_count > ? AND expiration_date >= ?", 0, DateTime.now)
    end
  end

  extend Scopes

  validates :expiration_date, :available_count, :presence => true

  def self.searchable_columns
    [:name, :description]
  end

  def considered_active?
    available_count > 0 && expiration_date >= DateTime.now
  end

  def calculate_amount(count)
    return nil unless (count.blank? or count.is_a?(Fixnum))
    if count.blank?
      price
    else
      price * count if (count > 0 && count <= available_count)
    end
  end
end
