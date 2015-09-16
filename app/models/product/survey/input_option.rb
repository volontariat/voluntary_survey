class Product::Survey::InputOption
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::MassAssignmentSecurity
  include Mongoid::Orderable
  
  embedded_in :task, class_name: 'Product::Survey::Task', inverse_of: :options
  
  field :key, type: String
  field :value, type: String
  
  orderable
  
  attr_accessible :option, :key, :value
end