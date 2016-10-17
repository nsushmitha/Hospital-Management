require 'spec_helper'

RSpec.describe PatientsController, :type => :controller  do
  
 
  describe "GET 'index'" do
    let!(:first_post)  { Patients.create(:name => "Test get name", :age => 27, :gender => "F") }
    before { get :index, :format => :json }
    
   
    it "returns status code :success" do
      expect(response.status).to eq 200
    end
 
    it "renders the index template" do
      response.body.should_not eq("")
    end
    
    it "response body @patients" do
      body = JSON.parse(response.body)
      patient_name = body.map { |m| m["patients"]["name"] }
      patient_age = body.map { |m| m["patients"]["age"] }
      patient_gender = body.map { |m| m["patients"]["gender"] }
      expect(patient_name).to match_array(["Test get name"])
      expect(patient_age).to match_array([27])
      expect(patient_gender).to match_array(["F"])
    end
  end

  describe "GET /patients/:id" do
    it "returns a requested patient" do
      a = Patients.create(:name => "Test name1", :age => 27, :gender => "F")
      get :show, :id => a.id, :format => :json

      expect(response.status).to be 200

      body = JSON.parse(response.body)

      expect(:get => "/patients/#{a.id}").to be_routable
      expect(body["patients"]["name"]).to eq "Test name1"
      expect(body["patients"]["age"]).to eq 27
      expect(body["patients"]["gender"]).to eq "F"
    end
  end

  describe "POST /patients" do

    it "creates an patient" do
      patient_params = {
        "patient" => {
          "name"   => "Test create name",
          "age"    => 27,
          "gender" => "F"
        }
      }

      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      before_count = Patients.count
      post :create, patient_params
      
      before_count = before_count + 1
      after_count = Patients.count
      expect(before_count).to eq after_count
      expect(Patients.first.name).to eq "Test create name"
      expect {
        post :create, patient_params
      }.to change(Patients, :count).by(1)
    end
  end


   describe "DELETE /patients/:id" do
    it "deletes an patient" do
      a = Patients.create(:name => "Test name1", :age => 27, :gender => "F")

      before_count = Patients.count
      delete :destroy, :id => a.id, :format => :json

      expect(response.status).to be 200
      expect(Patients.count).to eq 0
    
      before_count = before_count - 1
      after_count = Patients.count

      expect(before_count).to eq after_count
      a = Patients.create(:name => "Test name2", :age => 27, :gender => "F")
       expect {
         delete :destroy, :id => a.id
       }.to change(Patients, :count).by(-1)

    end
  end
end