class Product::Survey::Result < ::Result
  belongs_to :task, class_name: 'Product::Survey::Task'
end