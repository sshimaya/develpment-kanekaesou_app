class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :creditor_id
      t.string :debtor_name
      t.text :goods
      t.string :status
      t.date :registration_date

      t.timestamps
    end
  end
end
