class AddScoreDefaultValue < ActiveRecord::Migration
  def change
    change_column :enrollments, :score, :integer,default:0
  end
end
