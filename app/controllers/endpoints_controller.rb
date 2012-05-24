class EndpointsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :ensure_authentication_token

  make_resourceful do
    actions :all

    response_for :index do |format|
      format.json { render :json => @endpoints }
      format.xml { render :xml => @endpoints }
    end

    response_for :show do |format|
      format.json { render :json => @endpoint }
      format.xml { render :xml => @endpoint }
    end
  end

end
