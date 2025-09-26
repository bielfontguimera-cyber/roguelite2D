if (instance_number(obj_Enemies) == 0) {
    var R = global.room_grid[room_index(global.curX, global.curY)];
    if (!is_undefined(R) && !R.cleared) {
        R.cleared = true;
        global.room_grid[room_index(R.x, R.y)] = R;
        with (obj_Door_Parent) if (passable) locked = false;
    }
}

world_update(); // ← detecta “boss mort” i fa trampilla+ítem+portes

