class Transaction < ApplicationRecord

  validates :debtor_name, {presence: true}
  validates :goods, {presence: true}
  validates :registration_date, {presence: true}

end
