Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # Auth
  namespace :auth do
    get  "/signup", to: "signup#index"
    post "/signup", to: "signup#create"
    get  "/signin", to: "signin#index"
    post "/signin", to: "signin#create"
  end

  # PointCards - Owned by current user
  get "/point_cards/owned",        to: "point_cards/owned#index"
  
  # PointCards - Collaborated with current user
  get "/point_cards/collaborated", to: "point_cards/collaborated#index"

  # PointCards - Issued to current user
  get "/point_cards/issued",       to: "point_cards/issued#index"

  # PointCards
  get     "/point_cards",                  to: "point_cards#index"
  post    "/point_cards/:point_card_name", to: "point_cards#create"
  get     "/point_cards/:point_card_name", to: "point_cards#show"
  put     "/point_cards/:point_card_name", to: "point_cards#update"
  delete  "/point_cards/:point_card_name", to: "point_cards#delete"

  # Collaborators
  get    "/point_cards/:point_card_name/collaborators/",     to: "point_cards/collaborators#index"
  post   "/point_cards/:point_card_name/collaborators/:uid", to: "point_cards/collaborators#create"
  get    "/point_cards/:point_card_name/collaborators/:uid", to: "point_cards/collaborators#show"
  put    "/point_cards/:point_card_name/collaborators/:uid", to: "point_cards/collaborators#update"
  delete "/point_cards/:point_card_name/collaborators/:uid", to: "point_cards/collaborators#delete"

  # PointIssueUnits
  get    "/point_cards/:point_card_name/issue_units",          to: "point_cards/issue_units#index"
  post   "/point_cards/:point_card_name/issue_units",          to: "point_cards/issue_units#create"
  get    "/point_cards/:point_card_name/issue_units/:unit_id", to: "point_cards/issue_units#show"
  put    "/point_cards/:point_card_name/issue_units/:unit_id", to: "point_cards/issue_units#update"
  delete "/point_cards/:point_card_name/issue_units/:unit_id", to: "point_cards/issue_units#delete"

  # PointCollectUnits
  get    "/point_cards/:point_card_name/collect_units",          to: "point_cards/collect_units#index"
  post   "/point_cards/:point_card_name/collect_units",          to: "point_cards/collect_units#create"
  get    "/point_cards/:point_card_name/collect_units/:unit_id", to: "point_cards/collect_units#show"
  put    "/point_cards/:point_card_name/collect_units/:unit_id", to: "point_cards/collect_units#update"
  delete "/point_cards/:point_card_name/collect_units/:unit_id", to: "point_cards/collect_units#delete"

  # PointCardIssues
  post    "/point_cards/:point_card_name/issues",      to: "point_cards/issues#create"
  get     "/point_cards/:point_card_name/issues/:no",  to: "point_cards/issues#show"
  delete  "/point_cards/:point_card_name/issues/:no",  to: "point_cards/issues#delete"

  # IssuePointCards - QR
  get "/point_cards/:point_card_name/issues/:no/qr", to: "point_cards/issues/qr#index"

  # Points
  post   "/point_cards/:point_card_name/issues/:no/points",     to: "point_cards/issues/points#create"

  # Points - Total
  get   "/point_cards/:point_card_name/issues/:no/points/total",to: "points#get"
end
