json.id         collaborator.id
json.created_at collaborator.created_at
json.updated_at collaborator.updated_at
json.permission collaborator.permission

json.user do
  json.uid    collaborator.user.uid
  json.name   collaborator.user.name
  json.gender collaborator.user.gender
end