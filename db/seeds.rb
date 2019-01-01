# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.skip_callback(:create, :after, :create_wick)
user = User.new(email: 'lifewick.dev@gmail.com', password: 'Lifewick123', first_name: 'life', last_name: 'wick', user_name: 'lifewick')
user.save(validate: false)
User.set_callback(:create, :after, :create_wick)
Wick.find_or_create_by(name: "Lifewick", user_id: user.id)