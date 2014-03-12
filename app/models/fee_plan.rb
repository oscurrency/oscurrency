class FeePlan < ActiveRecord::Base
  validates_presence_of	:name
  validates_length_of :name,  :maximum => 100
  validates_length_of :description,  :maximum => 255

  has_many :people, :dependent => :restrict
  has_many :recurring_fees, :dependent => :destroy, :inverse_of => :fee_plan

  accepts_nested_attributes_for :recurring_fees

  default_scope :order => 'name ASC'
end
