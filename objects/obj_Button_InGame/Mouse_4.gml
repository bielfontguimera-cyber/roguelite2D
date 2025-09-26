if (hovered) {
    switch (action) {
        case 0: room_goto(rm_Action);  global.floor = 1;  break;               // Jugar (posa aquí la room del joc)
        case 1: room_goto(rm_menu_options); break;       // Opcions
        case 2: room_goto(rm_menu_main);  global.floor = 1; instance_destroy(obj_CameraFocus) break;
        case 3: game_end(); break;
         
                           
    }
}             // Sortir