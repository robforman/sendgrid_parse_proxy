class EmailsController < ApplicationController
  make_resourceful do
    actions :all
    belongs_to :endpoint
    
    after :create do
      params.each do |k, v|
        # don't log or proxy internal stuff
        next if %w(action controller endpoint_id).include? k

        logger.debug "#{k} => #{v}"
        @email.params.create(:key => k, :value => v)
      end
    end

    response_for :create do |format|
      format.json { render :json => @email }
    end
  end

end
