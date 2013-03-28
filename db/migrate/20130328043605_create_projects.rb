class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :size
      t.string :provider

      t.timestamps
    end
  end
end
