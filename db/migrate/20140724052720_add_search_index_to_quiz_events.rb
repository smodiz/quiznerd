class AddSearchIndexToQuizEvents < ActiveRecord::Migration
  
  def up
    execute "create index quiz_event_status on quiz_events using gin(to_tsvector('english',status))"
  end

  def down
    execute "drop index quiz_event_status"
  end

end
