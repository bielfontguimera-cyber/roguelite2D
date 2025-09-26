// frames
if (passable) image_index = locked ? 1 : 0; else image_index = 2;

// mantenir estat d’overlap: si ja no hi ha jugador tocant, reseteja
player_overlapping = place_meeting(x, y, obj_Player);