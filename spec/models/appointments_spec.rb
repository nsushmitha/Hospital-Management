require 'spec_helper'

describe Appointments do

  before do
  	time = Time.new(2016,11,11,10,0)
    @appointment = Appointments.new(appointment_time: time)
  end
  
  subject { @appointment }

  it { should respond_to(:appointment_time) }
  it { should be_valid }

  describe "should have a time" do
    before { @appointment.appointment_time = " " }
    it { should_not be_valid }
  end

  describe "time exceeding limit" do
  	times = ["Nov 12th 2016 9:00 pm", "Nov 12th 2016 10:00 pm","Nov 12th 2015 11:00 am",
  		     "Nov 12th 2016 6:00 pm", "Dec 9th 2016 8:30 am" , "Jan 20th 2017 10:17 am"]
       times.each do |time|
        invalid_time = Time.parse(time)
       	before { @appointment.appointment_time = invalid_time }
    	  it { should_not be_valid }
    end
  end

  describe "time in limit" do
  	times = ["Nov 12th 2016 5:30 pm", "Nov 12th 2016 9:00 pm","Nov 12th 2016 1:00 pm"]
       times.each do |time|
        invalid_time = Time.parse(time)
       	before { @appointment.appointment_time = invalid_time }
    	it { should be_valid }
    end
  end
end