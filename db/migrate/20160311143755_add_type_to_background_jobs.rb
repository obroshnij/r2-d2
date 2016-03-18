class AddTypeToBackgroundJobs < ActiveRecord::Migration
  def change
    add_column :background_jobs, :job_type, :string
    add_index  :background_jobs, :job_type
    
    add_column :background_jobs, :meta,     :jsonb
  end
end