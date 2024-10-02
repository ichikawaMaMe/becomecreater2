class Dm < ApplicationRecord
    varidates :message, presence: true, length: {maximum: 140}   #これなに？
    belongs_to :user
    belongs_to :dmroom
end
