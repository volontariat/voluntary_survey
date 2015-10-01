class Product::Survey::Task < ::Task
  include Mongoid::Orderable
  
  belongs_to :page, class_name: 'Product::Survey::Page', inverse_of: :tasks
  
  embeds_many :options, class_name: 'Product::Survey::InputOption', inverse_of: :task
  has_many :results, class_name: 'Product::Survey::Result', foreign_key: 'task_id', dependent: :destroy
  
  field :answer_type, type: String
  
  validates :name, presence: true, uniqueness: { scope: :story_id }
  validates :answer_type, presence: true
  
  orderable
  
  attr_accessible :position, :answer_type
  
  def with_options?
    ['Multiple choice', 'Checkboxes', 'Drop-down list'].include? answer_type
  end

  protected
  
  def with_offeror; false; end
end