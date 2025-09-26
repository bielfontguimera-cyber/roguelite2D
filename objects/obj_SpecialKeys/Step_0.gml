if (keyboard_check_pressed(vk_f11)) {
    var fs = !window_get_fullscreen();
    window_set_fullscreen(fs);

    // recalibra les coordenades GUI
    display_set_gui_maximize();
}
// pausa overlay
if (keyboard_check_pressed(vk_escape)) {
    pause_show = !pause_show;
    
   if (!global.paused) {
        global.paused = true;
        instance_deactivate_all(true);
        instance_activate_object(obj_SpecialKeys); // el menú segueix actiu
        instance_activate_object(obj_Button_InGame);
        instance_activate_object(obj_Door_Parent);
    } else {
        global.paused = false;
        instance_activate_all();
    }
        
}

 