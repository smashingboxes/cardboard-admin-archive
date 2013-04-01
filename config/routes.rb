Cardboard::Engine.routes.draw do

  
  get "*id", :to => "pages#show", as: "public"
end
