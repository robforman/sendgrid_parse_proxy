class EmailsController < ApplicationController
  make_resourceful do
    actions :all
    belongs_to :endpoint
    
    after :create do
      logger.critical "raw_body => #{request.raw_body}"
      email.params.create(:key => 'raw_body', :value => request.raw_body)

      params.each do |k, v|
        # don't log or proxy internal stuff
        next if %w(action controller endpoint_id).include? k

        logger.critical "#{k} => #{v}"
        # @email.params.create(:key => k, :value => v)
      end
    end

    response_for :create do |format|
      format.all { render :nothing => true, :status => 200 }
    end
  end

end
