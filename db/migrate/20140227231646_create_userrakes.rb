class CreateUserrakes < ActiveRecord::Migration
  def change
    create_table :userrakes do |t|
      t.string :routes

      t.timestamps
    end
  end
end
