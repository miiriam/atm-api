class Transaction < ActiveRecord::Base
  belongs_to :user
  validates :amount, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true
end
