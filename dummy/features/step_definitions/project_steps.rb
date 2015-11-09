Given /^a survey project$/ do
  product = Product::Survey.create(name: 'Survey')
  area = FactoryGirl.create(:area, name: 'Dummy')
  @project = FactoryGirl.create(:project, product_id: product.id, name: 'Dummy', text: 'Dummy', area_ids: [area.id], user_id: @me.id)
end