json.created_at   issue.point_card.created_at
json.updated_at   issue.point_card.updated_at
json.name         issue.point_card.name
json.display_name issue.point_card.display_name
json.description  issue.point_card.description
json.image_url    issue.point_card.image_url

json.set! :issue do
  json.created_at issue.created_at
  json.updated_at issue.updated_at
  json.no         issue.no
  json.point      issue.no

  # json.set! :user do
  #   json.created_at    issue.user.created_at
  #   json.updated_at    issue.user.updated_at
  #   json.uid           issue.user.uid
  #   json.name          issue.user.name
  #   json.gender        issue.user.gender
  #   json.date_of_birth issue.user.date_of_birth
  # end
end