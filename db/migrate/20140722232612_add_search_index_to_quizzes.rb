class AddSearchIndexToQuizzes < ActiveRecord::Migration
  def up
    execute "create index quiz_name on quizzes using gin(to_tsvector('english',name))"
    execute "create index quiz_description on quizzes using gin(to_tsvector('english',description))"  
  end

  def down
    execute "drop index quiz_name"
    execute "drop index description_name"
  end
end
