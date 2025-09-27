if (hovered) {
    switch (action) {
        case 0: room_goto(rm_Action);  global.floor = 1;  break;               // Jugar (posa aquí la room del joc)
            // Opcions
        case 1: room_goto(rm_menu_main);  global.floor = 1; break;
        case 2: game_end(); break;
         
                           
    }
}             // Sortir