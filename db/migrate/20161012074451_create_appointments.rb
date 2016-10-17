class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :appointment_time
      t.references :doctors
      t.references :patients
      t.timestamps
    end
  end
end
