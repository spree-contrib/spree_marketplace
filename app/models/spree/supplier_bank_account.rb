module Spree
  class SupplierBankAccount < ActiveRecord::Base

    attr_accessor :account_number, :routing_number

    belongs_to :supplier

    validates :country_iso,    presence: true
    validates :masked_number,  presence: true
    validates :name,           presence: true
    validates :supplier,       presence: true
    validates :token,          presence: true, uniqueness: true

  end
end
