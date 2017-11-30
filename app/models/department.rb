class Department < ApplicationRecord
  # belongs_to :department

  def self.init_data

	(1..10).each do |i|
		p i
		Department.create(
			name: "部门#{i}"
			) 
	end
  	
  end
end
