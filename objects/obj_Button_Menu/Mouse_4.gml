if (hovered) {
    switch (action) {
        case 0: room_goto(rm_Action); break;               // Jugar (posa aquí la room del joc) // Opcions
        case 1: room_goto(rm_menu_controls); break; 
        case 2: game_end(); break;
                            
    }
}           // Sortir