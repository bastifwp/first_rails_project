#Acá es donde hacemos las asociaciones entre las tablas

class Friend < ApplicationRecord
  belongs_to :user #Asociacion con tabla de user
end
