class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.text :name, null: false
      t.integer :status, default: 0
      t.integer :priority, default: 50

      t.timestamps

      t.index :name
      t.index :id, unique: true
      t.index :status
    end
  end
end
