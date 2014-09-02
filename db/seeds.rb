# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Setting.create(key: 'email_on_booking', value: false)
Setting.create(key: 'email_on_sign_out', value: false)
Setting.create(key: 'email_on_sign_in', value: false)
Setting.create(key: 'email_from_address', value: 'ADDRESS@GOES.HERE')
Setting.create(key: 'site_name', value: 'Bookings')