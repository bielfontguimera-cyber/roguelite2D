
if (pause_show) {
    // enfosqueix la pantalla (veus el joc al darrere)
  
    
    var cx = ROOM_MIN_X -100 + (ROOM_MAX_X/2);
    var cy = ROOM_MIN_Y-100 + (ROOM_MAX_Y/2);
    
    var labels = ["Reset","Opcions","Menu" ,"Sortir" , "Resume: Press ESC"];
    var actions = [0, 1, 2, 3, 4,];
    
    var spacing = 20;

    
    draw_set_color(c_black);
    draw_set_alpha(0.5);
  
    draw_set_alpha(1);
    
   

    // centra tots els botons respecte el centre vertical
    for (var i = 0; i < array_length(labels); i++) {
        var yy = cy - (array_length(labels) * spacing * 0.5) + i * spacing;
        var b = instance_create_layer(cx, yy, "Instances_Controlers", obj_Button_InGame);
        b.text   = labels[i];
        b.action = actions[i];
    }
        } else {
            // destrueix els botons de pausa (distingir-los amb un flag si cal)
            with (obj_Button_InGame)  instance_destroy();
            }
        
    
    // (Els botons de pausa es dibuixen sols al seu Draw GUI)

    

