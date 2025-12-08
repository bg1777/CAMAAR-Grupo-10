class AddFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :matricula, :string
    add_column :users, :curso, :string
    add_column :users, :formacao, :string
    add_column :users, :ocupacao, :string
  end
end
