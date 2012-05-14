class Endpoint < ActiveRecord::Base
  has_many :emails

  validates :proxy_url, :presence => true, :length => { :maximum => 256 }
end
