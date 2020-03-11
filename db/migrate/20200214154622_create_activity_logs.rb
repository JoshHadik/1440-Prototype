class CreateActivityLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :activity_logs do |t|
      t.datetime :started_at
      t.datetime :ended_at
      t.string :label
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
  end
end
