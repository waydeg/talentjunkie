class Admin::ExternalFeedEntryPublishersController < AdminController
  
  def index
    raise "Asd"
  end
  
  def create
    begin
      @entry = ExternalFeedEntry.find(params[:entry_id])
      @organization = Organization.find_or_create_organization_by_name(params["entry_#{@entry.id}_organization"])
    
      raise ActiveRecord::ActiveRecordError.new if @entry.organizations.include?(@organization)
      @link = ExternalFeedEntriesOrganization.create!({:external_feed_entry_id => @entry.id, :organization_id => @organization.id})
      @entry.update_attribute(:classified, 1)
      
      render :json => {:url => admin_external_feed_entries_path(@entry.external_feed)}, :status => 201
      
    rescue ActiveRecord::ActiveRecordError
      render :json => :ok, :status => 406
    rescue
      render :json => :ok, :status => 406
    end
  end

  def publish
    begin
      @entry = ExternalFeedEntry.find(params[:entry_id])
      @organization = Organization.find(params[:id])

      ActiveRecord::Base.connection.execute("UPDATE external_feed_entries_organizations SET publish_count = publish_count + 1 WHERE external_feed_entry_id = #{@entry.id} AND organization_id = #{@organization.id}")
      Events::PostPublished.create!({:object_id => @organization.id, :subject_id => @entry.id})
      
      redirect_to admin_external_feed_entries_path(@entry.external_feed)
    rescue
      raise
    end
  end
  
  def destroy
    @entry = ExternalFeedEntry.find(params[:entry_id])
    ActiveRecord::Base.connection.execute("DELETE FROM external_feed_entries_organizations WHERE external_feed_entry_id = #{@entry.id} AND organization_id = #{params[:id]}")
    redirect_to admin_external_feed_entries_path(@entry.external_feed)
  end
end