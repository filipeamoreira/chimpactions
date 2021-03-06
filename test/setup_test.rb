require 'test_helper'
require 'chimpactions/setup'

class SetupTest < ActiveSupport::TestCase
  context "With a good initializer" do
    setup do
      Chimpactions.setup({'mailchimp_api_key' => "goodfake_mailchimp_api_key",
        'mailchimp_ses_key' => "goodfake_mailchimp_ses_key",
        'merge_map' => {
          'FNAME'=> 'first_name',
          'LNAME' => 'last_name',
          'EMAIL' => 'email',
          'FAV_COL' => 'favorite_color'},
        'local_model' => 'User'})
    end
  
    should "set authorization keys and be ok?" do
      assert_equal Chimpactions.mailchimp_api_key, "goodfake_mailchimp_api_key"
      assert_equal Chimpactions.mailchimp_ses_key, "goodfake_mailchimp_ses_key"
      Chimpactions::Setup.ensure_initialization
      assert_equal Chimpactions::Setup.ok?, true
    end
    
    should "fail to connect with a bad API key" do
      assert_equal Chimpactions::Setup.verify, false
    end
    
  end

  context "With no initializer" do 
    setup do
      Chimpactions.setup({'mailchimp_api_key' => nil,
        'mailchimp_ses_key' => nil,
        'merge_map' => nil,
        'local_model' => 'User'})
    end
  
    should "cause initialization failure" do
      setup = Chimpactions::Setup.ensure_initialization
      assert_equal Chimpactions::Setup.ok?, false
    end
  end
  
  context"With default initializer" do
    setup do
      @setup_hash = 
        {'mailchimp_api_key' => "your_mailchimp_api_key",
        'mailchimp_ses_key' => "your_mailchimp_ses_key",
        'merge_map' => {
          'FNAME'=> 'first_name',
          'LNAME' => 'last_name',
          'EMAIL' => 'email',
          'FAV_COL' => 'favorite_color'},
        'local_model' => 'YourLocalModel'}
    end

    should "setup initializer" do
      @setup_hash['mailchimp_api_key'] = '1234567890'
      @setup_hash['local_model'] = "User"
      Chimpactions.setup(@setup_hash)
      setup = Chimpactions::Setup.ensure_initialization
      assert_equal Chimpactions::Setup.message, "Chimpactions::Setup.initialize"
    end
  
    should "cause initialization failure with defaults" do
      assert_raise(Chimpactions::SetupError) { Chimpactions.setup(@setup_hash) }
    end
  
  end

end