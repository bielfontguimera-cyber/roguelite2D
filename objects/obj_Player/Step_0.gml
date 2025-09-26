// Step del player
if (hp <= 0 && !global.gameover) {
    global.gameover = true;
    image_alpha = 0; // amaga’l si vols
}

hsp = (keyboard_check(ord("D")) - keyboard_check(ord("A"))) * move_speed;
vsp = (keyboard_check(ord("S")) - keyboard_check(ord("W"))) * move_speed;

move_and_collide(hsp, vsp, tilemap);


if (hsp != 0 or vsp != 0) {
    last_angle = point_direction(0, 0, hsp, vsp);

    if (vsp > 0)       sprite_index = Mistery_Idle_Down;
    else if (vsp < 0)  sprite_index = Mistery_Idle_Up;
    else if (hsp > 0)  sprite_index = Mistery_Idle_Right;
    else if (hsp < 0)  sprite_index = Mistery_Idle_Left;
}        

if (fire_cooldown > 0) {
    fire_cooldown -= 1;
}
    

var shoot_x = keyboard_check(vk_right) - keyboard_check(vk_left);
var shoot_y = keyboard_check(vk_down)  - keyboard_check(vk_up);

// Normalitza el vector de moviment perquè només indiqui direcció
var move_x = sign(hsp);
var move_y = sign(vsp);

// 4) Si hi ha input de dispar i som a zero cooldown
if ((shoot_x != 0 or shoot_y != 0) and fire_cooldown <= 0) {
    
 
    
    // 6) Combina vectors amb aquest pes
    var final_x = shoot_x + move_x * w;
    var final_y = shoot_y + move_y * w;
   
     if (final_x == 0 and final_y == 0) {
        final_x = shoot_x; final_y = shoot_y;
    }
    
    // 7) Calcula angle i dispara
    var final_angle = point_direction(0, 0, final_x, final_y);
    scr_shoot(final_angle, current_bullet);
}


if (invincible) {
    // Comptador per canviar alpha i fer parpellejar
    blink_timer -= 1 / room_speed;
    if (blink_timer <= 0) {
        // Alternar visibilitat
        image_alpha = (image_alpha == 1) ? 0.4 : 1;
        blink_timer = blink_interval;
    }
} else {
    // Assegurar opacitat normal quan no és invencible
    if (image_alpha != 1) {
        image_alpha = 1;
    }
}