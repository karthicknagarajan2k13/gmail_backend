class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :user_id
      t.string :to
      t.string :subject
      t.text :message
      t.boolean :is_active, default: false

      t.timestamps null: false
    end
  end
end
