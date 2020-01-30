local sprite = CreateSprite(0, 0, "Witch_Sprite_Sheet")

CreateAnimation(sprite, "idle", {1, 2, 3, 4}, true)
CreateAnimation(sprite, "run", {5, 6, 7, 8, 9, 10, 11, 12}, true)
CreateAnimation(sprite, "cast", {13, 14, 15, 16, 17, 18, 19, 20}, false)
CreateAnimation(sprite, "hit", {21, 22, 23, 24}, false)
CreateAnimation(sprite, "death", {25, 26, 27, 28, 29, 30, 31, 32, 33, 34}, false)

return sprite
