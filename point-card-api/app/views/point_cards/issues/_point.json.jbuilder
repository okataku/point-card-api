json.id              point.id
json.created_at      point.created_at
json.updated_at      point.updated_at
json.issuer do
  json.uid  point.issuer ? nil : point.issuer.uid
  json.name point.issuer ? nil : point.issuer.name
end
json.issued_at       point.issued_at
json.total           point.total
json.point           point.point
json.remaining_point point.remaining_point
json.expired         point.expired
json.expires_in      point.expires_in
json.expired_at      point.expired_at