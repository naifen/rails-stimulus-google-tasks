class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      # Authlogic::ActsAsAuthentic::Email
      t.string    :email
      t.index     :email, unique: true

      # Authlogic::ActsAsAuthentic::Login
      t.string    :username, null: false
      t.index     :username, unique: true

      t.string    :phone_number
      t.index     :phone_number, unique: true
      t.string    :phone_verification_token
      t.index     :phone_verification_token, unique: true
      t.datetime  :pvt_sent_at # phone verification token sent at

      # Authlogic::ActsAsAuthentic::Password
      t.string    :crypted_password, null: false
      t.string    :password_salt, null: false

      # Authlogic::ActsAsAuthentic::PersistenceToken
      t.string    :persistence_token
      t.index     :persistence_token, unique: true

      # Authlogic::ActsAsAuthentic::SingleAccessToken
      t.string    :single_access_token
      t.index     :single_access_token, unique: true

      # Authlogic::ActsAsAuthentic::PerishableToken
      t.string    :perishable_token
      t.index     :perishable_token, unique: true

      # Authlogic::Session::MagicColumns
      t.integer   :login_count, default: 0, null: false
      t.integer   :failed_login_count, default: 0, null: false
      t.datetime  :last_request_at
      t.datetime  :current_login_at
      t.datetime  :last_login_at
      t.string    :current_login_ip
      t.string    :last_login_ip

      # Authlogic::Session::MagicStates
      t.boolean   :active, default: false
      t.boolean   :approved, default: false
      t.boolean   :confirmed, default: false

      t.timestamps
    end
  end
end
