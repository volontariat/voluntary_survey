class Product::Survey::Story < Story
  embeds_many :pages, class_name: 'Product::Survey::Page', inverse_of: :story
  
  def submit_page(page_position, user)
    next_page_position = pages.where(:position.gt => page_position).order_by(position: 'asc').first.try(:position)
   
    unless next_page_position
      self.users_without_tasks_ids ||= []
      self.users_without_tasks_ids << user.id
      save
    end
    
    return next_page_position
  end
  
  protected
  
  def with_offeror; false; end
end