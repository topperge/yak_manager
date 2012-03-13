#lib/tasks/import.rake
namespace :import do
desc "Imports a CSV file into contractors model"
# TODO calculate contractor_files history model
task :csv_model_import, [:filename, :company_id, :contractor_file_id] => :environment do |task,args|
  if args.count != 3
      puts ''
      puts "rake csv_model_import[filename, company_id, contractor_file_id]"
      puts "  filename: The path to the csv filename from RAILS_ROOT to be uploaded"
      puts "  company_id: The company_id of the file being upload"
      puts "  contractor_file_id: The contractor_file_id of the file being upload"
      puts ''
      puts "example:"
      puts "  rake csv_model_import[test/fixtures/1.1500_records.csv,'4','4']"
      puts ''
  else
    lines = File.new(args[:filename]).readlines
    keys = ["clid","email"]
    # TODO Remove this truncate line once we have the base loads done the way we want
    Contractor.delete_all
    
    # Setup all the counts for the contractor_files record
    users_found = 0
    users_created = 0
    users_updated = 0
    users_deleted = 0
    users_errored = 0
    users_not_changed = 0
     
    lines.each do |line|
      params = {}
      values = line.strip.split(',')
      if values[1].end_with?('ctr.uberether.com')
        params[keys[0]]    = values[0]
        params[keys[1]]    = values[1]
        params['company_id'] = args[:company_id].to_i
        params['contractor_file_id'] = args[:contractor_file_id].to_i
        Contractor.create(params)
        i = i + 1
      end
    end
    puts i.to_s + ' Records Written'
  end
end
end