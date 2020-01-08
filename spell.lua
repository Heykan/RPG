function AddSpell(pSprite, pName)
  local spell = dofile("spells/"..pName..".lua")
  spell.fx = CreateFx(spell.fxId, spell.width, spell.height, spell.maxFrame, spell.interval)

  spell.target = nil

  spell.isRemovable = false

  table.insert(pSprite.spells, spell)

  if pSprite.isControllable then
    CreateSpell(pSprite)
  end
end

function PlaySpell(pOwner, pSpell, pTarget)
  if pSpell.isReady then
    PlayFx(pSpell.fx, pTarget)
    pSpell.isReady = false
    pSpell.target = pTarget
    LoseHp(pOwner, pTarget, pSpell.damage)
    pOwner.mana = pOwner.mana - pSpell.cost
  end
end
