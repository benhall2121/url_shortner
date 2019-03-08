class Url < ApplicationRecord
	has_many :clicks, dependent: :destroy
end
