class AddUserRefToTeam < ActiveRecord::Migration[5.1]
  def change
    add_reference :teams, :monitor, foreign_key: { to_table: :people }
  end
end
