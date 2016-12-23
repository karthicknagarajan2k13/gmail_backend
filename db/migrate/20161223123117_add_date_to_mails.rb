class AddDateToMails < ActiveRecord::Migration
  def change
  	add_column :emails, :date, :string
  end
end
