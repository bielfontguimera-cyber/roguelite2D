if (global.gameover != true) exit;
    
    var xx = display_get_gui_width() * 0.5;
    var yy = display_get_gui_height() * 0.5;
    
    draw_set_alpha(0.5);
    draw_set_color(c_black);
    draw_rectangle(0, 0, 2000, 1500, false);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_set_font(fnt_4);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(xx, yy - 100, "Game Over");
    draw_set_font(fnt_3);
    draw_text(xx, yy + 50, "Pres ESC to open the menu")

