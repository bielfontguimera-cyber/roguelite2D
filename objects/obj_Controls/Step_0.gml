if (keyboard_check_pressed(vk_escape)) {
    room_goto(rm_menu_main); 
    with (obj_Button_InGame)  instance_destroy();
    
} 

if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}

  

        
