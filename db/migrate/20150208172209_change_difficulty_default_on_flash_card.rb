class ChangeDifficultyDefaultOnFlashCard < ActiveRecord::Migration
  def up
    change_column_default :flash_cards, :difficulty, "1"
  end

  def down
    change_column_default :flash_cards, :difficulty, null
  end
end
