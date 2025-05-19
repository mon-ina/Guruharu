Rails.application.routes.draw do
  # 検索画面をトップページとして使う
  root 'restaurants#search'

  # 検索画面（GET /restaurants/search）
  get 'restaurants/search', to: 'restaurants#search', as: :search_restaurants

  # 検索結果画面（GET /restaurants）
  resources :restaurants, only: [:index, :show]

  # デフォルトの health check
  get "up" => "rails/health#show", as: :rails_health_check
end
