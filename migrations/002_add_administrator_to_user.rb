Sequel.migration do
  up do
    add_column :users, :administrator, :boolean, :default => false
  end

  down do
    drop_column(:users, :administrator)
  end
end
