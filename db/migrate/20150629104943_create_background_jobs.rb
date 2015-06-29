class CreateBackgroundJobs < ActiveRecord::Migration
  def change
    create_table :background_jobs do |t|
      t.references :user
      t.jsonb      :data, limit: nil
      t.string     :status
      t.string     :info

      t.timestamps null: false
    end
  end
end