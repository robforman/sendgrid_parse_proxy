class EndpointsController < ApplicationController

  make_resourceful do
    actions :all
    
    response_for :show do |format|
      format.json { render :json => @endpoint }
    end
  end

end
