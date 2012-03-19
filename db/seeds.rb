# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Company.delete_all
User.delete_all

google = Company.create!(name: 'Google', description: 'Gmail peeps should be able to edit me.')
private_corp = Company.create!(name: 'Private Corp', description: 'Only superusers should be able to edit me.')

joe = User.create(email: 'joe@gmail.com', company_id: google.id, password: 'password', role: 'user')
bob = User.create(email: 'bob@privatecorp.com', company_id: nil, password: 'password', superadmin: 'true', role: 'superuser')
