require 'texticle/searchable'

class Post < ActiveRecord::Base
  include ActivityLogger
  has_many :activities, :as => :item, :dependent => :destroy

  extend Searchable(:body)
end
