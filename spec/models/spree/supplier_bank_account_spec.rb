require 'spec_helper'

describe Spree::SupplierBankAccount do

  it { should belong_to(:supplier) }

  it { should validate_presence_of(:masked_number) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:supplier) }
  it { should validate_presence_of(:token) }
  it { should validate_uniqueness_of(:token) }

end
