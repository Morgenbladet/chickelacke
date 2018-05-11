class AddNicknameToCards < ActiveRecord::Migration[5.2]
  def change
    add_column :cards, :nickname, :string
  end
end
