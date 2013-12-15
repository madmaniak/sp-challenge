SpChallenge::Application.routes.draw do
  root to: 'offers#show'
  match '/' => 'offers#index', via: :post
end
