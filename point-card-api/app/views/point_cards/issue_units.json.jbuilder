json.array! @issue_units do |issue_unit|
  json.partial! partial: '/point_cards/issue_unit', locals: { issue_unit: issue_unit }
end