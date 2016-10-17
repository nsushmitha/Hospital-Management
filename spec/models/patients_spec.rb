require 'spec_helper'

describe Patients do

  before do
    @patient = Patients.new(name: "Daniel", age: 27, gender: "F")
  end
  
  subject { @patient }

  it { should respond_to(:name) }
  it { should respond_to(:age) }
  it { should respond_to(:gender) }
  it { should be_valid }

  describe "should have a name" do
    before { @patient.name = " " }
    it { should_not be_valid }
  end
 
  
  describe "length of name exceeding limit" do
    before { @patient.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "length of name within limit" do
    before { @patient.name = "a" * 50 }
    it { should be_valid }
  end

  describe "should have a age" do
    before { @patient.age = " " }
    it { should_not be_valid }
  end

  describe "age not in limit" do
    it "should be invalid" do
      age = [0,-2,100,105]
      age.each do |invalid_age|
        @patient.age = invalid_age
        @patient.should_not be_valid
      end
    end
  end

  describe "age within limit" do
    it "should be valid" do
      age = [1,60,99]
      age.each do |valid_age|
        @patient.age = valid_age
        @patient.should be_valid
      end
    end
  end

  describe "should have a gender" do
    before { @patient.gender = " " }
    it { should_not be_valid }
  end

  describe "gender not in specified values" do
    it "should be invalid" do
      gender = %w[female male]
      gender.each do |invalid_gender|
        @patient.gender = invalid_gender
        @patient.should_not be_valid
      end
    end
  end

  describe "age within limit" do
    it "should be valid" do
      gender = %w[f M]
      gender.each do |valid_gender|
        @patient.gender = valid_gender
        @patient.should be_valid
      end
    end
  end

end