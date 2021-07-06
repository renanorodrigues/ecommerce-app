json.licenses do
  json.array! @licenses, :id, :key, :status, :platform, :game_id, :user_id
end