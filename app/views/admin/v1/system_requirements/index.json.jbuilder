json.system_requirements do
  json.array! @system_requirements, :id, :name, :storage, :processor, :memory, :video_board, :operational_system
end