class TableRow
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attr_reader :data
  
  def initialize hash
    @data = hash
  end
  
  NAMES = [
    "Alexander E.",
    "Alexey D.",
    "Andrey Ba.",
    "Anton Kh.",
    "Eugene K.",
    "Igor I.",
    "Igor R.",
    "Igor Ru.",
    "Ivan Zharikov",
    "Kate K.",
    "Maria S.",
    "Max K.",
    "Maxim S.",
    "Nadine P.",
    "Oleg K.",
    "Oleg Ko.",
    "Sergey Bo.",
    "Sergey Ch.",
    "Sergey P.",
    "Sergey Se.",
    "Stas G.",
    "Taras K.",
    "Valentin P.",
    "Vasiliy T.",
    "Victor L.",
    "Vladimir Bu.",
    "Vladimir Burov",
    "Vladimir Sarkisyan"
  ]
  
  ## Validations
  
  validate  :valid_created_at
  validates :name, inclusion: { in: NAMES }
  validates :ticket_id, format: { with: /\A\w\w\w\-\d\d\d\-\d\d\d\d\d\Z/i }, allow_nil: true
  
  def valid_created_at
    errors.add :created_at, 'is invalid' unless created_at.is_a? DateTime
  end
  
  ## Attributes
  
  def created_at
    DateTime.strptime data[:timestamp], "%m/%d/%Y %H:%M:%S"
  rescue
    data[:timestamp]
  end
  
  def name
    data[:name]
  end
  
  def ticket_id
    return nil if data[:ticket_id].nil?
    id = data[:ticket_id].match(/\w\w\w\-\d\d\d\-\d\d\d\d\d/).to_s
    id.length.zero? ? nil : id
  end
  
  def la_comment
    data[:ticket_id] unless data[:ticket_id] =~ /\A\w\w\w\-\d\d\d\-\d\d\d\d\d\Z/i
  end
  
  def server_name
    data[:server_name]
  end
  
end