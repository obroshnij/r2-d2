class CreateLegalPdfReports < ActiveRecord::Migration
  def change
    create_table :legal_pdf_reports do |t|
      t.integer :created_by_id, index: true
      t.integer :edited_by_id,  index: true
      t.string  :username,      index: true
      t.date    :expires_on
      t.jsonb   :content,       default: { pages: {}, order: [] }

      t.timestamps null: false
    end
  end
end
