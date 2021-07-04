json.system_requirements do
  json.array! @loading_service.records, :id, :name, :storage, :processor, :memory, :video_board, :operational_system
end

json.meta do
  json.partial! 'shared/pagination', pagination: @loading_service.pagination
end