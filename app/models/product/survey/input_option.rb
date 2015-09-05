class Product::Survey::InputOption
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::MassAssignmentSecurity
  
  embedded_in :task, class_name: 'Product::Survey::Task', inverse_of: :options
  
  field :value, type: String
  
  attr_accessible :value
end