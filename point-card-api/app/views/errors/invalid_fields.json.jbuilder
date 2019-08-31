json.message 'Invalid Fields'

if @errors.any?
  json.errors @errors.messages do |field, messages|
    messages.each do |message|
      json.resource @resource_name
      json.field field
      json.message "#{field} #{message}"
    end
  end
end
