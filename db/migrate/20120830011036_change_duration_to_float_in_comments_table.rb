class ChangeDurationToFloatInCommentsTable < ActiveRecord::Migration
  def up
  	change_column :comments, :duration, :float, :default => 0
  end

  def down
  	change_column :comments, :duration, :integer, :default => nil
  end
end
