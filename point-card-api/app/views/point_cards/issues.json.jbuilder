json.array! @issues do |issue|
  json.partial! "/point_cards/issue", locals: { issue: issue }
end