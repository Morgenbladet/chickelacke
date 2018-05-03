Rails.application.routes.draw do
  resources 'cards', only: [:create, :show]
end
