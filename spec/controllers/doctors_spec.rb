require 'spec_helper'

RSpec.describe DoctorsController, :type => :controller  do
  
 
  describe "GET 'index'" do
    let!(:first_post)  { Doctors.create(:name => "Test get name", :category => "Test get category") }
    before { get :index, :format => :json }
    
   
    it "returns status code :success" do
      expect(response.status).to eq 200
    end
 
    it "renders the index template" do
      response.body.should_not eq("")
    end
    
    it "response body @doctors" do
      body = JSON.parse(response.body)
      doctor_name = body.map { |m| m["doctors"]["name"] }
      doctor_category = body.map { |m| m["doctors"]["category"] }
      expect(doctor_name).to match_array(["Test get name"])
      expect(doctor_category).to match_array(["Test get category"])
    end
  end

  describe "GET /doctors/:id" do
    it "returns a requested doctor" do
      a = Doctors.create(:name => "Test name1", :category => "Test category1")
      get :show, :id => a.id, :format => :json

      expect(response.status).to be 200

      body = JSON.parse(response.body)

      expect(:get => "/doctors/#{a.id}").to be_routable
      expect(body["doctors"]["name"]).to eq "Test name1"
    end
  end

  describe "POST /doctors" do

    it "creates an doctor" do
      doctor_params = {
        "doctor" => {
          "name" => "Test create name",
          "category" => "Test create category"
        }
      }

      request_headers = {
        "Accept" => "application/json",
        "Content-Type" => "application/json"
      }

      before_count = Doctors.count
      post :create, doctor_params
      
      before_count = before_count + 1
      after_count = Doctors.count
      expect(before_count).to eq after_count
      expect(Doctors.first.name).to eq "Test create name"
      expect {
        post :create, doctor_params
      }.to change(Doctors, :count).by(1)
    end
  end


   describe "DELETE /doctors/:id" do
    it "deletes an doctor" do
      a = Doctors.create(:name => "Test name1", :category => "Test category1")

      before_count = Doctors.count
      delete :destroy, :id => a.id, :format => :json

      expect(response.status).to be 200
      expect(Doctors.count).to eq 0
    
      before_count = before_count - 1
      after_count = Doctors.count

      expect(before_count).to eq after_count
      a = Doctors.create(:name => "Test name2", :category => "Test category2")
       expect {
         delete :destroy, :id => a.id
       }.to change(Doctors, :count).by(-1)

    end
  end
end