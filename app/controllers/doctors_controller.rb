class DoctorsController < ApplicationController

  def index
    doctor = Doctors.all
    render json:doctor.to_json
  end

  def show
    doctor = Doctors.find(params[:id]) if params[:id].present?
    if(doctor.present?)
      render json:doctor.to_json
    else
      result["status"] = "Failure - Invalid Doctor ID"
      render json:result.to_json
    end
  end

	def create
		doctor = Doctors.create(message_params)
		result = {"status" => "",
              "doctor_id" => nil}
    	if doctor.save 
    		result["status"] = "Success"
        result["doctor_id"] = doctor.id
    	  render json:result.to_json
    	else 
    		result["status"] = "Failure"
      	render json:result.to_json
    	end 
	end

  def update
    doctor = Doctors.find(params[:id])
    if(doctor.present?)
      doctor.update_attributes(message_params)
      result = {"status" => "Success"}
    else
      result = {"status" => "Failure - Invalid doctor id"}
    end
    render json:result.to_json
  end

  def destroy
    doctor = Doctors.find(params[:id])
    time = Time.now
    if(doctor.present?)
      # If history has to be retained
      # scope = Appointments.joins(:doctors).where("appointments.doctors_id = ? AND appointments.appointment_time >= ?",doctor.id,time)
      # scope.destroy if scope.present?
      if doctor.destroy
        result = {"status" => "Success"}
      else
       result = {"status" => "Failure"}
      end
    else
      result = {"status" => "Failure - Doctor ID does not exist"}
    end
    render json:result.to_json
  end

  private
    def message_params
        params.require(:doctor).permit(:name,:category) 
    end

end
