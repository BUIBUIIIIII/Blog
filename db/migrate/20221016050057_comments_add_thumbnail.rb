class CommentsAddThumbnail < ActiveRecord::Migration[6.1]
  def change
    add_column :articles, :thumbnail, :string
  end
end
