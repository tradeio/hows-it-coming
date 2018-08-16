module TasksHelper
  def task_card(task)
    content_tag(:div, class: 'task-card') do
      content_tag(:p, class: 'task-name') do
        "#{task.name}"
      end +

      content_tag(:small, class: 'task-updated-at') do
        "Updated #{task.updated_at.strftime('%D')}"
      end
    end
  end
end
