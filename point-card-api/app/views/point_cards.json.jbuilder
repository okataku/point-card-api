json.array! @point_cards do |point_card|
  json.partial! "/point_card", locals: { point_card: point_card }
end