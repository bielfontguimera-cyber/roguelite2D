if (hovered) {
    switch (action) {
        case 0: room_goto(rm_Action); break;               // Jugar (posa aquí la room del joc)
        case 1: room_goto(rm_menu_options); break;       // Opcions
        case 2: room_goto(rm_menu_controls); break;
              // Controls
        case 4: game_end(); break;
                            
    }
}           // Sortir