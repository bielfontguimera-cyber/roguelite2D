var p = instance_place(x, y, obj_Player);

if (player_overlapping ) {
    global.floor += 1;                 // incrementa abans del restart
    show_debug_message("FLOOR++ -> " + string(global.floor)); // debug
    room_restart();
}