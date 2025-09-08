class CreateWorkoutPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :workout_plans do |t|
      t.string :title, null: false
      t.text :description
      t.string :difficulty, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
