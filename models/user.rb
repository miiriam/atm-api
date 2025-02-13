require 'bcrypt'

class User < ActiveRecord::Base
  validates :account_number, presence: true, uniqueness: true
  validates :pin, presence: true, length: { is: 60 } # Para almacenar hash bcrypt
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def pin=(new_pin)
    self[:pin] = BCrypt::Password.create(new_pin)
  end

  def authenticate(input_pin)
    BCrypt::Password.new(self.pin) == input_pin
  end
end
