class PatientsController < ApplicationController

  def index
    patient = Patients.all
    render json:patient.to_json
  end

  def show
    patient = Patients.find(params[:id]) if params[:id].present?
    if(patient.present?)
      render json:patient.to_json
    else
      result["status"] = "Failure - Invalid Patient ID"
      render json:result.to_json
    end
  end

	def create
		@patient = Patients.create(message_params) 
		result = {"status" => "",
              "patient_id" => nil}
    	if @patient.save 
    		result["status"] = "Success"
        result["patient_id"] = @patient.id
    	  render json:result.to_json
    	else 
    		result["status"] = "Failure"
      	render json:result.to_json
    	end 
	end

  def update
    @patient = Patients.find(params[:id])
    if(@patient.present?)
      @patient.update_attributes(message_params)
      result = {"status" => "Success"}
    else
      result = {"status" => "Failure - Invalid patient id"}
    end
    render json:result.to_json
  end

  def destroy
    patient = Patients.find(params[:id])
    time = Time.now
    if(patient.present?)
      # If history has to be retained
      # scope = Appointments.joins(:patients).where("appointments.patients_id = ? AND appointments.appointment_time >= ?",doctor.id,time)
      # scope.destroy if scope.present?
      if patient.destroy
        result = {"status" => "Success"}
      else
       result = {"status" => "Failure"}
      end
    else
      result = {"status" => "Failure - Patient ID does not exist"}
    end
    render json:result.to_json
  end

  private
    def message_params
      params.require(:patient).permit(:name, :age, :gender) 
    end

end
