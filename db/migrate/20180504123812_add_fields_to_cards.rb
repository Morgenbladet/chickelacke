class AddFieldsToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :address, :string
    add_column :cards, :phone, :string
    add_column :cards, :slogan, :string
    add_column :cards, :member_of, :string
    add_column :cards, :color, :string
  end
end
