class Product::Survey::Task < ::Task
  embedded_in :page, class_name: 'Product::Survey::Page', inverse_of: :tasks
  embeds_many :options, class_name: 'Product::Survey::InputOption', inverse_of: :input
  has_many :results, class_name: 'Product::Survey::Result', foreign_key: 'task_id', dependent: :destroy
  
  field :position, type: Integer
  
  attr_accessible :position
  
  protected
  
  def with_offeror; false; end
end