class CreateNicknames < ActiveRecord::Migration[5.2]
  def change
    create_table :nicknames do |t|
      t.integer :p_id
      t.string :nick

      t.timestamps
    end
  end
end
