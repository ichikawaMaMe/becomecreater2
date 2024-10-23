class CreateTagTables < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_tables do |t|
      #referensesにすることでindexが自動付与され、外部キーであるpostとtagも不要にしている。index処理について勉強
      t.references :post, foreig_key: true, null: false
      t.references :tag, foreign_key: true, null: false
      t.timestamps
    end
    add_index :tag_tables, [:post_id, :tag_id], unique: true
  end
end
