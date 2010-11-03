ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'front', :action => 'index'
  map.resource :about, :controller => 'about'
  map.resource :contact, :controller => 'contact'
  map.resources :portfolio, :controller => 'portfolio'
  map.datasource '/swf/datasource', :controller => 'front'

end
