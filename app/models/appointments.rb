class Appointments < ActiveRecord::Base
  attr_accessible :appointment_time, :doctors_id, :patients_id
  validate :appointment_time_in_working_hours, :before => :create
  validates :appointment_time,:presence => true
  belongs_to :patients
  belongs_to :doctors

  def appointment_time_in_working_hours
    if (appointment_time.present?)
    	t= appointment_time
    	start_time = Time.new(t.year, t.month, t.day, 9, 0, 0, t.utc_offset)
    	end_time  = Time.new(t.year, t.month, t.day, 17, 30, 0, t.utc_offset)
		  if (!((t.between?(start_time, end_time)) && ( t.min == 30 || t.min == 0 ) && (t > Time.now)))
      		errors.add(:appointment_time, "can't be out of working hours")
    	end
    end
  end    

end
