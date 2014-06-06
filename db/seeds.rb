# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
%w[Programming].each do |cat|
  Category.find_or_create_by(name: cat)
end

prog_id = Category.find_by(name: "Programming").id

['Software Development - General',
 'Unix',
 'Ruby',
 'Rails',
 'HTML/CSS',
 'Javascript',
 'Testing',
 'Databases',
 'OO Concepts and Design Patterns',
 'Data Structures and Algorithms'].each do |subj|
   Subject.find_or_create_by(name: subj, category_id: prog_id)
end