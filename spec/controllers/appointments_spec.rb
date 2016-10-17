require 'spec_helper'

RSpec.describe AppointmentsController, :type => :controller  do
  
 
  describe "GET 'index'" do
    time = Time.parse("2016 November 12th 14:00")
    let!(:first_post)  { Appointments.create(:appointment_time => time , :doctors_id => 1, :patients_id => 1) }
    before { get :index, :format => :json }
    
   
    it "returns status code :success" do
      expect(response.status).to eq 200
    end
 
    it "renders the index template" do
      response.body.should_not eq("")
    end
    
    it "response body @doctors" do
      body = JSON.parse(response.body)
      appointment_time = body.map { |m| m["appointments"]["appointment_time"] }
      appointment_time = DateTime.parse(appointment_time.to_s)
      get_time = DateTime.parse(time.to_s)
      appointment_doctor = body.map { |m| m["appointments"]["doctors_id"] }
      appointment_patient = body.map { |m| m["appointments"]["patients_id"] }
      expect(appointment_time).to eq get_time
      expect(appointment_doctor).to match_array([1])
      expect(appointment_patient).to match_array([1])
    end
  end

  describe "GET /appointments/:id" do
    time = Time.parse("2016 November 12th 14:00")
    it "returns a requested appointment" do
      a = Appointments.create(:appointment_time => time , :doctors_id => 1, :patients_id => 1)
      get :show, :id => a.id, :format => :json

      expect(response.status).to be 200

      body = JSON.parse(response.body)

      expect(:get => "/appointments/#{a.id}").to be_routable
      expect(body["appointments"]["doctors_id"]).to eq 1
    end
  end
end