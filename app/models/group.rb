require 'texticle/searchable'

class Group < ActiveRecord::Base
  include ActivityLogger
  extend PreferencesHelper
  
  validates_presence_of :name, :person_id
  attr_protected :mandatory

  mount_uploader :picture, ImageUploader

  has_one :forum
  has_many :reqs, :conditions => "biddable IS true", :order => "created_at DESC"
  has_many :offers, :order => "created_at DESC"
  has_many :exchanges, :order => "created_at DESC"
  has_many :memberships, :dependent => :destroy
  has_many :people, :through => :memberships, 
    :conditions => "status = 0", :order => "name DESC"
  has_many :pending_request, :through => :memberships, :source => "person",
    :conditions => "status = 2", :order => "name DESC"
  
  belongs_to :owner, :class_name => "Person", :foreign_key => "person_id"
  
  has_many :activities, :as => :item, :dependent => :destroy

  validates_uniqueness_of :name
  validates_uniqueness_of :unit, :allow_nil => true
  validates_uniqueness_of :asset, :allow_nil => true
  validates_format_of :asset, :with => /^[-\.a-z0-9]+$/i, :allow_blank => true
  validate :changing_asset_name_only_allowed_if_empty
  after_create :create_owner_membership
  after_create :create_forum
  after_create :log_activity
  before_update :update_member_credit_limits
  
  extend Searchable(:name, :description)
  
  # GROUP modes
  PUBLIC = 0
  PRIVATE = 1
  
  def get_groups_modes
    modes = []
    modes << ["Public",PUBLIC]
    modes << ["Membership approval required",PRIVATE] unless default_group?
    return modes
  end

  def default_group?
    id == Group.global_prefs.default_group_id
  end
  
  class << self

    def name_sorted_and_paginated(page = 1)
      paginate(:page => page,
               :per_page => RASTER_PER_PAGE,
               :order => "name ASC")
    end

    def by_opentransact(asset)
      Group.find_by_asset(asset)
    end
  end

  def opentransact?
    !asset.nil?
  end

  def admins
    admins = memberships.with_role('admin').map {|m| m.person}
    admins << owner if admins.empty?
    admins
  end

  def public?
    self.mode == PUBLIC
  end
  
  def private?
    self.mode == PRIVATE
  end
  
  def owner?(person)
    self.owner == person
  end

  private

  def changing_asset_name_only_allowed_if_empty
    unless new_record?
      if asset_changed?
        unless asset_was.blank?
          errors.add(:asset, "cannot be changed unless it is empty")
        end
      end
    end
  end

  def create_owner_membership
    mem = Membership.new( :status => Membership::PENDING )
    mem.person = self.owner 
    mem.group = self
    mem.roles = ['admin']
    mem.save
    Membership.accept(mem.person,mem.group)
  end

  def update_member_credit_limits
    if default_credit_limit_changed?
      transaction do
        memberships.each do |m|
          m.account.update_attributes!(:credit_limit => default_credit_limit)
        end
      end
    end
  end

  def log_activity
    activity = Activity.create!(:item => self, :person => Person.find(self.person_id))
    add_activities(:activity => activity, :person => Person.find(self.person_id))
  end
  
end
