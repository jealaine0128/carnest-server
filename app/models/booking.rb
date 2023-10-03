class Booking < ApplicationRecord
    belongs_to :operator
    belongs_to :user
  end