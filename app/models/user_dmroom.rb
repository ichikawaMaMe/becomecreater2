class UserDmroom < ApplicationRecord
    belongs_to :user
    belongs_to :dmroom
end
