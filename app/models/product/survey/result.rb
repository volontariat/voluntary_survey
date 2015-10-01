class Product::Survey::Result < ::Result
  belongs_to :task, class_name: 'Product::Survey::Task'
  
  after_create :increment_chosen_count_of_option, if: 'task.with_options?'
  after_update :update_chosen_count_of_options, if: 'text_changed? && task.with_options?'
  
  def increment_chosen_count_of_option
    if task.answer_type == 'Checkboxes'
      task.options.where(_id: { '$in' => JSON.parse(text) }).each do |option|
        option.update_attribute(:chosen_count, option.chosen_count.to_i + 1)
      end
    else
      option = task.options.where(_id: text).first
      option.update_attribute(:chosen_count, option.chosen_count.to_i + 1)
    end
  end
  
  def update_chosen_count_of_options
    if task.answer_type == 'Checkboxes'
      option_ids = JSON.parse(text)
      option_ids_was_array = JSON.parse(text_was)
      
      options = task.options.where(_id: { '$in' => (option_ids + option_ids_was_array).uniq }).index_by{|o| o.id.to_s}
      
      option_ids_was_array.select{|id| !option_ids.include?(id) }.each do |option_id_was|
        option = options[option_id_was]
        option.update_attribute(:chosen_count, option.chosen_count.to_i - 1)
      end
      
      option_ids.select{|id| !option_ids_was_array.include?(id) }.each do |option_id|
        option = options[option_id]
        option.update_attribute(:chosen_count, option.chosen_count.to_i + 1)
      end
    else
      option = task.options.where(_id: text).first
      option.update_attribute(:chosen_count, option.chosen_count.to_i + 1)
      
      option = task.options.where(_id: text_was).first
      option.update_attribute(:chosen_count, option.chosen_count.to_i - 1)
    end
  end
end