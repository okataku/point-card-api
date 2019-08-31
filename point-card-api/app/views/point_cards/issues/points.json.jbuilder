json.array! @points do |point|
  json.partial! "/point_cards/issues/point", locals: { point: point }
end