namespace :init do
	desc "department "
	task :department => :environment do
		Department.init_data
	end
end
