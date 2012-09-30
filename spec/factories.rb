FactoryGirl.define do
  factory :user do
    email    "test@test.com"
    password "testtest"
  end

  factory :account do 
    name "account name"
    currency "UAH"
    user
  end

  factory :transaction do
    text "test transaction"
    date Date.current().to_s(:db)
    transaction_type_id 1 # Outlay
    amount 100.32
    account
    user
  end  

end