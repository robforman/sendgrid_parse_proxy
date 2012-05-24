class EmailsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :ensure_authentication_token

  def create
    logger.info "VERBOSE: [request.raw_post] => #{request.raw_post}"
    @endpoint = Endpoint.find(params[:endpoint_id])

    new_params = Sendgrid::Parse::EncodableHash.new(params)
    new_params.encode!("UTF-8", ignore=%w(action controller endpoint_id verbose))
    new_params.each { |k, v| logger.info "VERBOSE: [#{k}] => #{v}" }

    response = Typhoeus::Request.post(@endpoint.proxy_url, :params => new_params)
    mail = Mail.new(new_params[:headers])

    @email = @endpoint.emails.build(
      :message_id => mail.message_id,
      :to => new_params[:to],
      :from => new_params[:from],
      :subject => new_params[:subject],
      :sent => true
    )

    unless response.code == 200
      logger.warn "Posting email to endpoint proxy_url #{@endpoint.proxy_url} failed with response code #{response.code} (#{response.curl_error_message})"
      @email.sent = false
      @email.error_message = response.curl_error_message
    end

    @email.save

    respond_to do |format|
      format.all { render :nothing => true, :status => response.code }
    end
  end
end
