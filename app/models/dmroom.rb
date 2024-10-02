class Dmroom < ApplicationRecord
    has_many :user_dmrooms, dependent: :destroy
    has_many :dms, dependent: :destroy
end
