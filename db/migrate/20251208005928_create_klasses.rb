class CreateKlasses < ActiveRecord::Migration[8.0]
  def change
    create_table :klasses do |t|
      t.string :code
      t.string :name
      t.string :semester
      t.text :description

      t.timestamps
    end
  end
end
