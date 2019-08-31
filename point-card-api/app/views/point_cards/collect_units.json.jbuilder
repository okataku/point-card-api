json.array! @collect_units do |collect_unit|
  json.partial! partial: '/point_cards/collect_unit', locals: { collect_unit: collect_unit }
end