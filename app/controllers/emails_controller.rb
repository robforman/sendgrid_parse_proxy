class EmailsController < ApplicationController
  def create
    logger.info "VERBOSE: request.raw_post => #{request.raw_post}" if params[:verbose]
    @endpoint = Endpoint.find(params[:endpoint_id])

    parse_email = Sendgrid::ParseEmail.new(params, encoding="UTF-8", ignore=%w(action controller endpoint_id verbose))
    parse_email.params.each { |k, v| logger.info "VERBOSE: #{k} => #{v}" } if params[:verbose]

    response = Typhoeus::Request.post(@endpoint.proxy_url, :params => parse_email.params)

    @email = @endpoint.emails.build(
      :message_id => parse_email.header(:message_id),
      :to => parse_email.to,
      :from => parse_email.from,
      :subject => parse_email.subject,
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
