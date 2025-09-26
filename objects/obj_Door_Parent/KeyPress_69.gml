var p = instance_place(x, y, obj_Player);
if (p != noone && passable &&  ! locked) {

    // 2) Calcula meitats del bbox del JUGADOR (aquí definim halfW/halfH)
    var halfW = 0.5 * (p.bbox_right  - p.bbox_left);
    var halfH = 0.5 * (p.bbox_bottom - p.bbox_top);

    // 3) Teletransporta segons la direcció de la porta (dx, dy)
    var tx = p.x, ty = p.y;

    if (dy == -1)      ty = ROOM_MAX_Y - halfH;   // porta de DALT → a BAIX
    else if (dy == 1)  ty = ROOM_MIN_Y + halfH;   // porta de BAIX → a DALT

    if (dx == 1)       tx = ROOM_MIN_X + halfW;   // porta de DRETA → a ESQUERRA
    else if (dx == -1) tx = ROOM_MAX_X - halfW;   // porta d'ESQUERRA → a DRETA

    // 4) Aplica TP dins del rectangle jugable
    p.x = clamp(tx, ROOM_MIN_X + halfW, ROOM_MAX_X - halfW);
    p.y = clamp(ty, ROOM_MIN_Y + halfH, ROOM_MAX_Y - halfH);

    // 5) (Opcional) canvi de sala lògica
    go_to_room(dx, dy);
}