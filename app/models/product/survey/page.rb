class Product::Survey::Page
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActiveModel::MassAssignmentSecurity
  include Mongoid::Orderable
  
  embedded_in :story, class_name: 'Product::Survey::Story', inverse_of: :pages
  has_many :tasks, class_name: 'Product::Survey::Task', inverse_of: :page
  
  field :name, type: String
  field :text, type: String
  
  orderable
  
  attr_accessible :story_id, :position, :name, :text
  
  protected
  
  def with_offeror; false; end
end