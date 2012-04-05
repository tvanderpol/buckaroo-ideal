require 'spec_helper'

describe Buckaroo::Ideal::OrderSignature do
  it 'generates a signature for the given order' do
    order  = mock invoice_number: 'EETNU-12345',
                  amount:         12.50,
                  test_mode:      true,
                  merchant_key:   'merchant_key'
    
    signature = Buckaroo::Ideal::OrderSignature.new(order, 'secret_key')
    
    expected_salt = [
      'merchant_key', # config.merchant_key
      'EETNU-12345',  # order.invoice_number
      1250,         # order.amount in cents
      1,            # 
      'secret_key'    # config.secret_key
    ].join
    
    Digest::MD5.should_receive(:hexdigest)
               .with(expected_salt)
    
    signature.to_s
  end
end