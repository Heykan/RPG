function PlaySE(pName)
  local se = love.audio.newSource("audio/se/"..pName..".wav", "stream")
  se:play()
end

function PlayBGM(pName, pVolume)
  local bgm = love.audio.newSource("audio/bgm/"..pName..".mp3", "stream")
  bgm:setVolume((pVolume or 1))
  bgm:setLooping(true)
  bgm:play()
end
