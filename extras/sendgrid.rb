require 'mail'

module Sendgrid
  # Author::  Rob Forman <rob@robforman.com>
  #
  # This class receives a params hash, typically posted from the SendGrid Parse engine
  # It inspects the params['charsets'] and tries to set encodings automatically, as well
  # as convert if different than desired.

  class ParseEmail
    attr_accessor :params

    def initialize(params, to_encoding="UTF-8", ignore=[])
      @params = params
      ignore.each { |e| @params.delete(e) if @params.has_key?(e)}

      # automatically set and/or change encoding the fields which they pass charsets
      if @params.has_key? :charsets
        charsets = JSON.parse(@params[:charsets])
        charsets.each do |key, from_encoding|
          if @params.has_key? key.to_sym
            value = @params[key.to_sym].force_encoding(from_encoding)

            if from_encoding.downcase != to_encoding.downcase
              @params[key.to_sym] = value.encode(to_encoding, :invalid => :replace, :undef => :replace, :replace => "?")
              charsets[key] = to_encoding
            end
          end
        end
        @params[:charsets] = charsets.to_json
      end
    end

    def header(name)
      return nil unless @params.has_key? :headers

      mail = Mail.new(@params[:headers])
      mail.header[name].to_s
    end

    # make params accessible for easy query
    def method_missing(sym, *args, &block)
      if @params.has_key? sym
        @params[sym]
      else
        super
      end
    end
  end
end