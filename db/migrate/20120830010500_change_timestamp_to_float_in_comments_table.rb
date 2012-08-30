class ChangeTimestampToFloatInCommentsTable < ActiveRecord::Migration
  def change
  	change_column :comments, :timestamp, :decimal, :default => 0
  end
end
