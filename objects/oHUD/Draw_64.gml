




if instance_exists(obj_Player) {
    var p = instance_find(obj_Player, 0);
    var hp = p.hp;
    var hp_max = p.hp_max;
    var bObj = p.current_bullet;
    var spd = p.move_speed;
    var bspd = p.bSpeed;


    
    // Recupera el dany del map del jugador
    var bDmg = obj_Player.damage;
    var bFRate = obj_Player.fire_rate;
   
    
    //
    // 1) Dibuixar la barra segmentada de vida
    //
    var x0      = 30;
    var y0      = 30;
    
    var x1 = 30;
    var y1 = 50;
    
    var total_w = 200;
    var h       = 24;
    var seg_w   = total_w / hp_max;
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // fons gris de cada segment
    draw_set_color(c_gray);
    for (var i = 0; i < hp_max; i++) {
        var sx = x0 + i * seg_w;
        draw_rectangle(sx, y0, sx + seg_w, y0 + h, false);
    }
    // omplir en verd segons vida actual
    draw_set_color(c_lime);
    for (var i = 0; i < hp; i++) {
        var sx = x0 + i * seg_w;
        draw_rectangle(sx + 1, y0 + 1, sx + seg_w - 1, y0 + h - 1, false);
    }
    // contorn negre de tota la barra
    draw_set_color(c_black);
    draw_rectangle(x0, y0, x0 + total_w, y0 + h, true);
    
    //
    // 2) Text de vida i dany de bala
    //
    // (opcional: si tens font pròpia, crida draw_set_font abans)
    
 
    var tHpW = "Hp: " + string(hp) + "/" + string(hp_max);
    var tDmgW = "Damage: " + string(bDmg);
    var tSpdW = "Speed: " + string(spd);
    var tFRateW = "Fire rate: " + string(bFRate);
    var tBspdW = "Bullet Speed: " + string(bspd);
    var tFlr = "Floor: " + string(global.floor);
    
    draw_set_alpha(0.5);
    draw_set_color(c_black);
    draw_rectangle(25, 65, 170, 205, false);
   

    draw_set_alpha(1);
    draw_set_font(fnt_1);
    draw_set_color(c_white);
    draw_text(x1, y1 + h + 6, tHpW);
    draw_text(x1, y1 + 20 + h + 6, tDmgW);
    draw_text(x1, y1 + 40 + h + 6, tSpdW);
    draw_text(x1, y1 + 60 + h + 6, tFRateW);
    draw_text(x1, y1 + 80 + h + 6, tBspdW);
    draw_text(x1, y1 + 100 + h + 6, tFlr);

    
    
}
