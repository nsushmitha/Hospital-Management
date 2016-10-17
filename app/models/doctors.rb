class Doctors < ActiveRecord::Base
  attr_accessible :name, :category
  validates :name,:presence => true,length: { maximum: 50 }
  validates :category, :presence => true, length: { maximum: 20 }
  has_many :appointments, class_name: Appointments, dependent: :destroy
end
