class Post < ActiveRecord::Base
  include ActivityLogger
  has_many :activities, :as => :item, :dependent => :destroy

  def self.searchable_columns
    [:body]
  end
end
