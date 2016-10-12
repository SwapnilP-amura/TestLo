require 'spec_helper'

describe "Employer" do

  def login(options={})
    visit "/"
    click_link "Sign In"
    fill_in "Email", :with => options[:email]
    fill_in "Password", :with => options[:password]
    click_button "Log in"
  end

  def update_profile(options={})
    click_link "Edit Profile"
    fill_in "Company",with:options[:company]
    fill_in "Company address",with:options[:address]
    fill_in "Contact",with:options[:phone]
    click_button "Update"
  end

  def create_test(options={})
    click_link "Create Test"
    fill_in "Name",with:options[:name]
    select @date.year.to_s,   :from => "test_date_1i"
    select @date.strftime("%B"),       :from => "test_date_2i"
    select @date.day.to_s,    :from => "test_date_3i"

    select @time.hour.to_s,:from=>"test_duration_4i"
    select @time.hour.to_s,:from=>"test_duration_5i"
    click_button "Create Test"
  end

  before(:example) do
     @employer=create(:employer)
     @employer.confirm
     @date=Date.today
     @time=Time.now
  end

  describe "Creation of test" do

    it "should redirect to profile completion before creating test" do
      login email:@employer.email,password:@employer.password
      click_link "My Tests"
      click_link "Create Test"
      page.should have_content("Complete profile first")
    end

    it "should allow to create/update profile" do
      login email:@employer.email,password:@employer.password
      update_profile company:"Amura",address:"Balewadi,Pune",phone:"9088229933"
      page.should have_content("Successfully")
    end

    it "can create test after completion of profile" do
      login email:@employer.email,password:@employer.password
      update_profile company:"Amura",address:"Balewadi,Pune",phone:"9088229933"
      create_test name:"Sampletest"
      page.should have_content("Test created Successfully")
    end


  end

end
