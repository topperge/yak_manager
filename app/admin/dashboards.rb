ActiveAdmin::Dashboards.build do
    
  # Define your dashboard sections here. Each block will be
  # rendered on the dashboard in the context of the view. So just
  # return the content which you would like to display.
  
  # == Simple Dashboard Section
  # Here is an example of a simple dashboard section
  #
  #   section "Recent Posts" do
  #     ul do
  #       Post.recent(5).collect do |post|
  #         li link_to(post.title, admin_post_path(post))
  #       end
  #     end
  #   end
  
  # == Render Partial Section
  # The block is rendered within the context of the view, so you can
  # easily render a partial rather than build content in ruby.
  #
     section "Recent Files" do
       ul do
         if current_user.superadmin?
           @contractorFileList = ContractorFile.limit(10).order("updated_at DESC").collect
         else 
           @contractorFileList = ContractorFile.where(:company_id=>current_user.company_id).limit(10).order("updated_at DESC").collect
         end
         table_for @contractorFileList do
            column ("File Name") { |cf| cf.csv_file_name }
            column :status, :sortable => :status do |cf|
              if cf.status == FILE_STATUS[0]
                div :class => "firstStatus leftAlign" do
                  cf.status
                end
              elsif cf.status == FILE_STATUS[1]
                div :class => "secondStatus leftAlign" do
                  cf.status
                end
              else  
                div :class => "thirdStatus leftAlign" do
                  cf.status
                end      
              end
            end
            column("Download") {|cf| link_to "Download File", cf.csv.url(:original, false) }
            column("Records Found") { |cf| cf.users_found }
            column("Users Created") { |cf| cf.users_created }
            column("Users Updated") { |cf| cf.users_updated }
            column("Users Deleted") { |cf| cf.users_deleted }
            column("Errors Found") { |cf| cf.users_errored }
            column("Users Not Changed") { |cf| cf.users_not_changed }
         end
       end
     end
     
=begin
       section "Background Jobs" do
         now = Time.now.getgm
         ul do
           li do
             jobs = Delayed::Job.where('failed_at is not null').count(:id)
             link_to "#{jobs} failing jobs", admin_jobs_path(q: {failed_at_is_not_null: true}), style: 'color: red'
           end
           li do
             jobs = Delayed::Job.where('run_at <= ?', now).count(:id)
             link_to "#{jobs} late jobs", admin_jobs_path(q: {run_at_lte: now.to_s(:db)}), style: 'color: hsl(40, 100%, 40%)'
           end
           li do
             jobs = Delayed::Job.where('run_at >= ?', now).count(:id)
             link_to "#{jobs} scheduled jobs", admin_jobs_path(q: {run_at_gte: now.to_s(:db)}), style: 'color: green'
           end
         end
       end
=end

  # == Section Ordering
  # The dashboard sections are ordered by a given priority from top left to
  # bottom right. The default priority is 10. By giving a section numerically lower
  # priority it will be sorted higher. For example:
  #
  #   section "Recent Posts", :priority => 10
  #   section "Recent User", :priority => 1
  #
  # Will render the "Recent Users" then the "Recent Posts" sections on the dashboard.
  
  # == Conditionally Display
  # Provide a method name or Proc object to conditionally render a section at run time.
  #
  # section "Membership Summary", :if => :memberships_enabled?
  # section "Membership Summary", :if => Proc.new { current_admin_user.account.memberships.any? }

end
