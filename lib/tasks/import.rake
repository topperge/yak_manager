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
      # TODO Remove this truncate line once we have the base loads done the way we want
      #Contractor.delete_all
      
      # Remove existing records for file_id if re-running load through command line
      ContractorFileRecord.destroy_all(:contractor_file_id => args[:contractor_file_id].to_i)
    
      require 'DevelopmentProfiler'

      fileParts = args[:filename].strip.split('/')
      filename   = fileParts[2]
      
      DevelopmentProfiler::prof("import-#{filename}") do
        # Create an array to hold all of the CLIDs for the file that has been uploaded
        # Even if a record is bad, we don't want to mark it deleted from the database
        # Bad records we just leave alone, these are truly deleted records we are targetting
        clids = Array.new
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
          flag = ''
          message = ''
          # Check if there are more or less than two values in the row and throw an error
          if values.length != 2
            users_errored += 1
            message = 'More than two values provided in line, must only contain two values'
            flag    = 'Bad Data'
          elsif values[1].end_with?('ctr.uberether.com')
            @contractor = Contractor.where(:clid => values[0], :company_id => args[:company_id].to_i).all
            if (@contractor.count == 1)
              @contractor = @contractor.first
              #If the user's email address hasn't change then don't do anything
              if @contractor.email.downcase == values[1].downcase
                users_not_changed += 1
                message = 'No change to the user, data already existed in table'
                flag    = 'Existing User'
              # User's email has changed update it here
              else
                @contractor.email = values[1].downcase
                @contractor.deleted = false
                @contractor.save
                users_updated += 1
                message = 'Email updated for user'
                flag    = 'Updated User'
              end
            #Two records for a single clid for a single company have been found. This is bad.
            elsif @contractor.count > 1
              users_errored += 1
              message = 'More than one record found in the database for this company for the requested clid'
              flag    = 'Bad Data'
            #Finally create a new user if they aren't found
            else 
              params['clid']               = values[0].downcase
              params['email']              = values[1].downcase
              params['deleted']            = false
              params['company_id']         = args[:company_id].to_i
              params['contractor_file_id'] = args[:contractor_file_id].to_i
              Contractor.create(params)
              users_created += 1
              message = 'New User Created Successfully'
              flag    = 'New User'
            end
          #Bad email address found
          else
            users_errored += 1
            message = 'Invalid email address provided, must end in .ctr.uberether.com'
            flag    = 'Bad Data'
          end
          ContractorFileRecord.create(:clid => values[0].downcase, :email => values[1].downcase, :flag => flag, :message => message, :contractor_file_id => args[:contractor_file_id].to_i, :company_id => args[:company_id].to_i, :record_id => users_found)
          clids << values[0].downcase
          users_found += 1
        end
        
        # Find Deleted Users
        @contractors = Contractor.where(:company_id => args[:company_id].to_i, :deleted => false)
        @contractors.each do |contractor|
          if !clids.include?(contractor.clid)
            contractor.update_attribute('deleted',true) 
            users_deleted += 1
          end
        end 
          
        puts users_found.to_s + ' Records Found in File'
        puts users_created.to_s + ' Records Created From File'
        puts users_updated.to_s + ' Records Updated From File'
        puts users_deleted.to_s + ' Records Deleted'
        puts users_errored.to_s + ' Records Errored in File'
        puts users_not_changed.to_s + ' Records Existing'
        @contractorfile = ContractorFile.find_by_id(args[:contractor_file_id].to_i)
        @contractorfile.users_created     = users_created
        @contractorfile.users_updated     = users_updated
        @contractorfile.users_deleted     = users_deleted
        @contractorfile.users_errored     = users_errored
        @contractorfile.users_not_changed = users_not_changed
        @contractorfile.users_found       = users_found
        @contractorfile.status            = 'Processing Completed'
        @contractorfile.save
      end
    end
  end
end