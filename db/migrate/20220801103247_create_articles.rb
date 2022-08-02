class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.text :title
      t.string :articles
      t.timestamps null: false
    end
  end
end
