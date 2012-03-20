class ContractorFile < ActiveRecord::Base
  belongs_to :user
  belongs_to :company
  has_many   :contractor_file_records, :dependent => :destroy
  has_attached_file :csv
  validates_attachment_presence :csv
  validates_attachment_content_type :csv, :content_type => ['text/csv','text/comma-separated-values','text/csv','application/csv','text/plain']
  validates_presence_of :company_id
  #validates :csv, :contractor_file => true
  
  attr_accessible :csv, :csv_file_name, :csv_content_type, :csv_file_size, :csv_updated_at, :users_created, :users_deleted, :users_updated, :users_errored, :status, :user_id, :company_id
    
  def display_name
    self.csv_file_name
  end
  
  def self.process_csv_file(iFilename, iCompany_id, iContractor_file_id)
    clids = Array.new
    # Setup all the counts for the contractor_files record
    users_found = 0
    users_created = 0
    users_updated = 0
    users_deleted = 0
    users_errored = 0
    users_not_changed = 0
 
    lines = File.new(iFilename).readlines
 
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
      elsif (values[1].end_with?('.ctr.uberether.com') && values[1].include?('@') )
        @contractor = Contractor.where(:clid => values[0], :company_id => iCompany_id.to_i).all
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
          params['company_id']         = iCompany_id.to_i
          params['contractor_file_id'] = iContractor_file_id.to_i
          Contractor.create(params)
          users_created += 1
          message = 'New User Created Successfully'
          flag    = 'New User'
        end
      #Bad email address found
      else
        users_errored += 1
        message = 'Invalid email address provided, must end in .ctr.uberether.com and contain and @ symbol'
        flag    = 'Bad Data'
      end
      ContractorFileRecord.create(:clid => values[0].downcase, :email => values[1].downcase, :flag => flag, :message => message, :contractor_file_id => iContractor_file_id.to_i, :company_id => iCompany_id.to_i, :record_id => users_found)
      clids << values[0].downcase
      users_found += 1
    end
    
    # Find Deleted Users
    @contractors = Contractor.where(:company_id => iCompany_id.to_i, :deleted => false)
    @contractors.each do |contractor|
      if !clids.include?(contractor.clid)
        contractor.update_attribute('deleted',true) 
        users_deleted += 1
        users_found += 1
      end
    end 
      
    puts users_found.to_s + ' Records Found in File'
    puts users_created.to_s + ' Records Created From File'
    puts users_updated.to_s + ' Records Updated From File'
    puts users_deleted.to_s + ' Records Deleted'
    puts users_errored.to_s + ' Records Errored in File'
    puts users_not_changed.to_s + ' Records Existing'
    @contractorfile = ContractorFile.find_by_id(iContractor_file_id.to_i)
    @contractorfile.users_created     = users_created
    @contractorfile.users_updated     = users_updated
    @contractorfile.users_deleted     = users_deleted
    @contractorfile.users_errored     = users_errored
    @contractorfile.users_not_changed = users_not_changed
    @contractorfile.users_found       = users_found
    @contractorfile.status            = 'File Ready for Import into Directories'
    @contractorfile.save
  end
  @contractorFile
end