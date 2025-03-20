class ChangeEndDateFromDateToDatetime < ActiveRecord::Migration[7.1]
  def change
    change_column :battles, :end_date, :datetime
  end
end
