class Patients < ActiveRecord::Base
	attr_accessible :name, :age, :gender
  validates :name,:presence => true,length: { maximum: 50 }
  validates_inclusion_of :age, in: 1..99
  validates :gender, :presence => true
  validates :gender, inclusion: %w(M F m f)
	has_many :appointments, class_name: Appointments, dependent: :destroy
end
