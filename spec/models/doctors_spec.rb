require 'spec_helper'
require 'rails_helper'


describe Doctors do

  before do
    @doctor = Doctors.new(name: "Shawn", category: "ENT")
  end
  
  subject { @doctor }

  it { should respond_to(:name) }
  it { should respond_to(:category) }
  it { should be_valid }

  describe "should have a name" do
    before { @doctor.name = " " }
    it { should_not be_valid }
  end
 
  
  describe "length of name exceeding limit" do
    before { @doctor.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "length of name within limit" do
    before { @doctor.name = "a" * 50 }
    it { should be_valid }
  end

  describe "should have a category" do
    before { @doctor.category = " " }
    it { should_not be_valid }
  end

  describe "length of category exceeding limit" do
    before { @doctor.category = "a" * 21 }
    it { should_not be_valid }
  end

  describe "length of category within limit" do
    before { @doctor.category = "a" * 20 }
    it { should be_valid }
  end
end