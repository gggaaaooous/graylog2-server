class StreamsController < ApplicationController
  filter_resource_access
  before_filter :tabs, :except => :index
  
  def index
    @new_stream = Stream.new
    if current_user.role_symbols.include? :admin
      @streams = Stream.all
    else
      @streams = current_user.streams
    end
  end

  def show
    @has_sidebar = true
    @load_flot = 3

    @messages = Message.all_of_stream @stream.id, params[:page]
    @total_count = Message.count_stream @stream.id

    # Find out if this stream is favorited by the current user.
    @is_favorited = current_user.favorite_streams.include?(@stream)
  end

  def rules
    @stream = Stream.find params[:id]
    @new_rule = Streamrule.new
  end

  def analytics
    @load_flot = true
    @stream = Stream.find params[:id]
  end

  def settings
    @stream = Stream.find params[:id]
  end

  def setdescription
    @stream = Stream.find(params[:id])
    @stream.description = params[:description]

    if @stream.save
      flash[:notice] = "Description has been saved."
    else
      flash[:error] = "Could not save description."
    end
    redirect_to stream_path(params[:id])
  end

  def togglealarmactive
    stream = Stream.find(params[:id])
    if stream.alarm_active
      stream.alarm_active = false
    else
      stream.alarm_active = true
    end

    stream.save

    # Intended to be called via AJAX only.
    render :text => ""
  end
  
  def togglealarmforce
    stream = Stream.find(params[:id])
    if stream.alarm_force
      stream.alarm_force = false
    else
      stream.alarm_force = true
    end

    stream.save

    # Intended to be called via AJAX only.
    render :text => ""
  end

  def setalarmvalues
    stream = Stream.find(params[:id])

    unless params[:limit].blank? or params[:timespan].blank?
      stream.alarm_limit = params[:limit]
      stream.alarm_timespan = params[:timespan]

      if stream.save
        flash[:notice] = "Alarm settings updated."
      else
        flash[:error] = "Could not update alarm settings."
      end
    else
        flash[:error] = "Could not update alarm settings: Missing parameters."
    end

    redirect_to :action => "settings", :id => params[:id]
  end

  def create
    new_stream = Stream.new params[:stream]
    if new_stream.save
      flash[:notice] = "Stream has been created"
    else
      flash[:error] = "Could not create stream"
    end
    redirect_to :action => "index"
  end
  
  def rename
    stream = Stream.find params[:stream_id]
    stream.title = params[:title]
    
    if stream.save
      flash[:notice] = "Stream has been renamed."
    else
      flash[:error] = "Could not rename stream."
    end

    redirect_to :controller => "streams", :action => "settings", :id => params[:stream_id]
  end

  def destroy
    stream = Stream.find params[:id]
    if stream.destroy
      flash[:notice] = "Stream has been deleted"
    else
      flash[:error] = "Could not delete stream"
    end
    stream.save
    redirect_to stream_path(stream)
  end
  
  def favorite
    stream = Stream.find params[:id]
    current_user.favorite_streams << stream
    
    flash[:notice] = "Stream has been added as a favorite!"
    redirect_to stream_path(stream)
  end

  def unfavorite
    stream = Stream.find params[:id]
    current_user.favorite_streams.delete stream
    flash[:notice] = "Stream has been removed from favorites!"
    redirect_to stream_path(stream)
  end
  
  def tabs
    @tabs = [ "Show", "Rules", "Analytics", "Settings" ]
  end
end
