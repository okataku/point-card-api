json.array! @collaborators do |collaborator|
  json.partial! "/point_cards/collaborator", locals: { collaborator: collaborator }
end