class AddProductSurvey < ActiveRecord::Migration
  def up
    if Product::Survey.first
    else
      Product::Survey.create(name: 'Survey', text: 'Dummy') 
    end
  end
  
  def down
    if product = Product::Survey.first
      product.destroy
    end
  end
end
