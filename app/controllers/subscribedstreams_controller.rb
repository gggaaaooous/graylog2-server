class SubscribedstreamsController < ApplicationController

def toggle
    stream_id = params[:id]
    # Check if the stream to favorite exists.
    stream = nil 
    begin
      stream = Stream.find(stream_id)
    rescue
      flash[:error] = "<strong>Could not subscribe to stream</strong><span>Stream does not exist.</span>"
      redirect_to :controller => "streams"
      return
    end

    if stream.subscribed?(current_user)
      destroy(stream_id)
    else
      create(stream_id)
    end

    # Only intended to be called via AJAX.
    render :text => ""
  end

  private

  def create(stream_id)
    subscription = SubscribedStream.new
    subscription.stream_id = stream_id
    subscription.user_id = current_user.id

    subscription.save
  end

  def destroy(stream_id)
    subscription = SubscribedStream.find_by_stream_id_and_user_id(stream_id, current_user.id)
    subscription.destroy
  end
end
