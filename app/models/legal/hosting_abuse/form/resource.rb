class Legal::HostingAbuse::Form::Resource
  
  include Virtus.model
  
  extend  ActiveModel::Naming
  include ActiveModel::Model
  include ActiveModel::Validations
  
  attribute :type_id,           Integer
  attribute :activity_type_id,  Integer
  attribute :measure_id,        Integer
  attribute :other_measure,     String
  attribute :folders,           String
  attribute :abuse_type_ids,    Array[Integer]
  attribute :lve_report,        String
  attribute :mysql_queries,     String
  attribute :process_logs,      String
  attribute :upgrade_id,        Integer
  attribute :impact_id,         Integer
  
  validates :type_id,              presence: true
  
  with_options if: :cron_jobs? do |f|
    f.validates :activity_type_id, presence: true
    f.validates :other_measure,    presence: true, if: :other_measure?
  end
  
  validates :folders,              presence: true, if: :disc_space?
  
  with_options if: :lve_mysql? do |f|
    f.validates :abuse_type_ids,   presence: { message: 'at least one must be checked' }
    f.validates :upgrade_id,       presence: true
    f.validates :impact_id,        presence: true
    f.validates :lve_report,       presence: true, if: :lve_report_required?
    f.validates :mysql_queries,    presence: true, if: :mysql_queries_required?
    f.validates :process_logs,     presence: true, if: :process_logs_required?
  end
  
  def cron_jobs?
    type_id == 1
  end
  
  def disc_space?
    type_id == 2
  end
  
  def lve_mysql?
    type_id == 3
  end
  
  def other_measure?
    measure_id == 3
  end
  
  def lve_report_required?
    intersection = abuse_type_ids & [1, 2, 3, 4]
    intersection.present?
  end
  
  def mysql_queries_required?
    abuse_type_ids.include? 5
  end
  
  def process_logs_required?
    abuse_type_ids.include? 6
  end
  
  def abuse_type_ids= ids
    super ids.delete_if(&:blank?)
  end
end