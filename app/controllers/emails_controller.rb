class EmailsController < ApplicationController
  def create
    logger.info "VERBOSE: request.raw_post => #{request.raw_post}"

    @endpoint = Endpoint.find(params[:endpoint_id])
    @email = @endpoint.emails.create

    parse_email = Sendgrid::ParseEmail.new(params, encoding="UTF-8", ignore=%w(action controller endpoint_id verbose))
    parse_email.params.each do |key, value|
      logger.info "VERBOSE: #{key} => '#{value}', #{key}.encoding => #{value.encoding}"
    end

    respond_to do |format|
      format.all { render :nothing => true, :status => 200 }
    end
  end
end
