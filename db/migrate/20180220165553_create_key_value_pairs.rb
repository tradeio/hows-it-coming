class CreateKeyValuePairs < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'hstore'

    create_table :key_value_pairs do |t|
      t.string :key
      t.hstore :value

      t.timestamps
    end
    add_index :key_value_pairs, :key
  end
end
