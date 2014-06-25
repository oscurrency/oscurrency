# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

  CATEGORIES = [
"Arts & Crafts",
"Building Services",
"Business & Administration",
"Children & Childcare",
"Computers",
"Counseling & Therapy",
"Food",
"Gardening & Yard Work",
"Goods",
"Health & Personal",
"Household",
"Miscellaneous",
"Music & Entertainment",
"Pets",
"Sports & Recreation",
"Teaching",
"Transportation",
"Education"
  ]

CATEGORIES.each do |value|
  category = Category.find_or_create_by_name(value, :description => "")
end

US_STATES = [
    [ 'Alabama', 'AL' ], 
    [ 'Alaska', 'AK' ], 
    [ 'Arizona', 'AZ' ], 
    [ 'Arkansas', 'AR' ], 
    [ 'California', 'CA' ], 
    [ 'Colorado', 'CO' ], 
    [ 'Connecticut', 'CT' ], 
    [ 'Delaware', 'DE' ], 
    [ 'District Of Columbia', 'DC' ], 
    [ 'Florida', 'FL' ], 
    [ 'Georgia', 'GA' ], 
    [ 'Guam', 'GU' ], 
    [ 'Hawaii', 'HI' ], 
    [ 'Idaho', 'ID' ], 
    [ 'Illinois', 'IL' ], 
    [ 'Indiana', 'IN' ], 
    [ 'Iowa', 'IA' ], 
    [ 'Kansas', 'KS' ], 
    [ 'Kentucky', 'KY' ], 
    [ 'Louisiana', 'LA' ], 
    [ 'Maine', 'ME' ], 
    [ 'Maryland', 'MD' ], 
    [ 'Massachusetts', 'MA' ], 
    [ 'Michigan', 'MI' ], 
    [ 'Minnesota', 'MN' ], 
    [ 'Mississippi', 'MS' ], 
    [ 'Missouri', 'MO' ], 
    [ 'Montana', 'MT' ], 
    [ 'Nebraska', 'NE' ], 
    [ 'Nevada', 'NV' ], 
    [ 'New Hampshire', 'NH' ], 
    [ 'New Jersey', 'NJ' ], 
    [ 'New Mexico', 'NM' ], 
    [ 'New York', 'NY' ], 
    [ 'North Carolina', 'NC' ], 
    [ 'North Dakota', 'ND' ], 
    [ 'Northern Mariana Islands', 'MP' ],
    [ 'Ohio', 'OH' ], 
    [ 'Oklahoma', 'OK' ], 
    [ 'Oregon', 'OR' ], 
    [ 'Pennsylvania', 'PA' ], 
    [ 'Puerto Rico', 'PR' ], 
    [ 'Rhode Island', 'RI' ], 
    [ 'South Carolina', 'SC' ], 
    [ 'South Dakota', 'SD' ], 
    [ 'Tennessee', 'TN' ], 
    [ 'Texas', 'TX' ], 
    [ 'Utah', 'UT' ], 
    [ 'Vermont', 'VT' ], 
    [ 'Virginia', 'VA' ], 
    [ 'Virgin Islands', 'VI' ],
    [ 'Washington', 'WA' ], 
    [ 'West Virginia', 'WV' ], 
    [ 'Wisconsin', 'WI' ], 
    [ 'Wyoming', 'WY' ]
  ]

US_STATES.each do |value|
  state = State.find_or_create_by_name( :name => value[0], :abbreviation => value[1] )
end

US_BUSINESS_TYPES = [
    "Sole Proprietor",
    "C-Corporation",
    "Partnership",
    "S-Corporation",
    "Trust",
    "Limited Liability Corporation",
    "Non-profit organization"
]

US_BUSINESS_TYPES.each do |value|
  type = BusinessType.find_or_create_by_name(value, :description => "")
end

TimeZone.find_or_create_by_time_zone('Pacific Time (US & Canada)')

FORM_TYPES = [
  ['BID: {{estimated_hours}} hours - {{req_name}}','See your <a href=\"{{request_url}}\">request</a> to consider bid', 'offered','en'],
  ['Bid accepted for {{req_name}}','See your <a href=\"{{request_url}}\">request</a> to consider bid','accepted','en'],
  ['Bid committed for {{req_name}}','Commitment made for your <a href=\"{{request_url}}\">request</a>. This is an automated message','commited','en'],
  ['Work completed for {{req_name}}','Work completed for your <a href=\"{{request_url}}\">request</a>. Please approve transaction! This is an automated message','completed','en'],
  
  ['You have received a payment of {{amount}} {{group_unit}} for {{metadata_name}}','{{customer_name}} paid you {{amount}} {{group_unit}}.','send_payment_notyfication','en'],
  ['Has recibido un pago de {{amount}} {{group_unit}} por {{metadata_name}}','{{customer_name}} te ha pagado {{amount}} {{group_unit}}.','send_payment_notyfication','es'],
  ['Vous avez reçu un paiement {{amount}} {{group_unit}} pour {{metadata_name}}','{{customer_name}} vous avez payé {{amount}} {{group_unit}}.','send_payment_notyfication','fr'],
  ['Έχετε λάβει μια πληρωμή από {{amount}} {{group_unit}} για {{metadata_name}}','{{customer_name}} σας πλήρωσε {{amount}} {{group_unit}}.','send_payment_notyfication','gr'],

  ['Payment suspended: {{amount}} {{group_unit}} by {{metadata_name}}','{{customer_name}} suspended payment of {{amount}} {{group_unit}}.','send_suspend_payment_notyfication','en'],
  ['Pago cancelado:  {{amount}} {{group_unit}} por {{metadata_name}}','{{customer_name}} pago cancelado de {{amount}} {{group_unit}}.','send_suspend_payment_notyfication','es'],
  ['Paiement suspendu: {{amount}} {{group_unit}} par {{metadata_name}}','{{customer_name}} paiement suspendu du {{amount}} {{group_unit}}.','send_suspend_payment_notyfication','fr'],
  ['Αναστολή πληρωμής: {{amount}} {{group_unit}} από {{metadata_name}}','{{customer_name}} αναστολή πληρωμής για {{amount}} {{group_unit}}.','send_suspend_payment_notyfication','gr']
]

FORM_TYPES.each do |value|
  SystemMessageTemplate.create(:title => value[0], :text => value[1], :message_type => value[2], :lang => value[3])
end

# default profile picture
preference = Preference.first
if preference.nil?
  # first install
  using_email = !!((ENV['SMTP_DOMAIN'] && ENV['SMTP_SERVER']) || ENV['SENDGRID_USERNAME']) # explicit true
  preference = Preference.create!(:app_name => (ENV['APP_NAME'] || "APP_NAME is Blank"), :server_name => ENV['SERVER_NAME'], :smtp_server => ENV['SMTP_SERVER'] || '', :email_notifications => using_email) 
  p = Person.new(:name => "admin", :email => "admin@example.com", :password => "admin", :password_confirmation => "admin", :description => "")
  p.save!
  p.admin = true
  p.email_verified = true
  p.save
  address = Address.new(person: p) # name is not used anywhere and cannot be mass assigned anyway
  address.save

  group_attributes = {:name => (ENV['APP_NAME'] || "Default Group"),
                      :description => "The system installation created this group with a currency and configured it as a mandatory group. All people who register on the system will automatically join all mandatory groups. By default, there is no credit limit configured for new account holders for this group although you may configure one.",
                      :mode => Group::PUBLIC,
                      :unit => 'hours',
                      :asset => 'hours',
                      :adhoc_currency => true
  }

  g = Group.new(group_attributes)
  g.owner = p
  g.save!
  g.mandatory = true
  g.save
  preference.default_group_id = g.id
  preference.save!

  p.default_group_id = g.id
  p.save!
end
