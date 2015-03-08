class ChangeDefaultStatusForQuizEvent < ActiveRecord::Migration
  def up
    change_column_default :quiz_events, :status, "Incomplete"
    QuizEvent.where(status: "In Progress").update_all(status: "Incomplete")
  end

  def down
    change_column_default :quiz_events, :status, "In Progress"
    QuizEvent.where(status: "Incomplete").update_all(status: "In Progress")
  end
end
