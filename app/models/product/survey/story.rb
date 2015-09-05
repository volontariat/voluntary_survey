class Product::Survey::Story < Story
  embeds_many :pages, class_name: 'Product::Survey::Page', inverse_of: :story
  
  protected
  
  def with_offeror; false; end
end