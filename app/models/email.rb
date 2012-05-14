class Email < ActiveRecord::Base
  belongs_to :endpoint
  has_many :params
end
