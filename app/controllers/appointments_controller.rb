class AppointmentsController < ApplicationController

  before_filter :validateParams,   :only => [:create, :update]

  def index
    appointment = Appointments.all
    render json:appointment.to_json
  end

  def show
    appointment = Appointments.find(params[:id]) if params[:id].present?
    if(appointment.present?)
      render json:appointment.to_json
    else
      result["status"] = "Failure - Invalid Appointment ID"
      render json:result.to_json
    end
  end

	def create
    if(@errors.present?)
      render json: @errors.to_json
      return 
    end
		if(params[:appointment][:patient_json].present?)
			@patient = Patients.new(patient_message_params) 
			if @patient.save
        params["patients_id"] = @patient.id
				create_appointment
      else
        @result = {"status" => "Failure - Unable to create patient id"}
      end
    else
      patient = Patients.find_by_id(params[:appointment][:patients_id])
      if(patient.present?)
        create_appointment
      else
        @result = {"status" => "Failure - Patient id not present"}
      end
		end
    render json: @result.to_json
	end

  def create_appointment
    if check_availability
      book_appointment
    else
      @result = {"status" => "Failure - Appointment not available"}
    end
  end

  def update
    if(@errors.present?)
      render json: @errors.to_json
      return 
    end
    @appointment = Appointments.find_by_id(params[:id])
    if (@appointment.present?)
      if check_availability
        update_appointment
        @result = {"status" => "Success"}
      else
        @result = {"status" => "Failure - Appointment not available"}
      end
    else
      @result = {"status" => "Failure - Invalid appointment id"}
    end
    render json:@result.to_json
  end

  def destroy
    @appointment = Appointments.find(params[:id])
    if @appointment.destroy
      @result = {"status" => "Success"}
    else
      @result = {"status" => "Failure - Invalid appointment id"}
    end
    render json:@result.to_json
  end

  def update_appointment
    appointment = Appointments.find(params[:id])
    appointment.update_attributes(message_params)
  end

  def book_appointment
    appointment = @scope2.appointments.create(message_params) 
    if appointment.save
      @result = {"status" => "Success",
                "Booking ID:" => appointment.id}
    else

    end
  end

  def check_availability
    time = Time.parse(params[:appointment][:appointment_time].to_s)|| @appointment[:appointment_time]
    category = params[:appointment][:category] || @appointment[:category]
    scope = Doctors.joins(:appointments).where("appointments.doctors_id = doctors.id AND doctors.category = ? AND appointments.appointment_time =?",category,time)
    booked_doctors = [-1]
    scope.map { |doctor| booked_doctors << doctor.id} if scope.present?
    @scope2 = Doctors.where('category = ? AND id NOT IN (?)',category,booked_doctors).find(:first)
    if @scope2.present?
      return true
    end
      return false
  end

  def validateParams
     if (params[:appointment][:appointment_time].present?)
      t = Time.parse(params[:appointment][:appointment_time])
      start_time = Time.new(t.year, t.month, t.day, 9, 0, 0, t.utc_offset)
      end_time  = Time.new(t.year, t.month, t.day, 17, 30, 0, t.utc_offset)
      if (!((t.between?(start_time, end_time)) && ( t.min == 30 || t.min == 0 ) && (t > Time.now)))
          @errors = "Invalid time"
      end
    else
      @errors = "No appointment time given"
    end
  end

  private

    def validate_message_params
      params.require(:appointment).permit(:appointment_time) 
    end

    def message_params
     params[:appointment][:appointment_time] = Time.parse(params[:appointment][:appointment_time])
     params.require(:appointment).permit(:appointment_time,:patients_id) 
    end

    def patient_message_params
     params[:patient_json] = params[:appointment][:patient_json]
     params.require(:patient_json).permit(:name,:age,:gender)
    end

end
