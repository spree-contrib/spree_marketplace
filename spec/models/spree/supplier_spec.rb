require 'spec_helper'

describe Spree::Supplier do

  it { should have_many(:bank_accounts) }

end
