class UpdateCertificationNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :amfr_expiry, :fr_expiry
    rename_column :users, :hcp_expiry, :bls_expiry
  end
end
