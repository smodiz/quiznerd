require 'factory_girl_rails' 

%w[Programming].each do |cat|
  Category.find_or_create_by(name: cat)
end

prog_id = Category.find_by(name: "Programming").id

['Software Development (General)',
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

['Private','Public','Archived'].each do |status|
  Status.find_or_create_by(name: status)
end
