hp_max         = 5;
hp             = hp_max;
move_speed     = 1.25;
damage         = 1;
fire_rate      = 25;
bSpeed         = 1.4;

hsp            = 0;
vsp            = 0;

tilemap        = layer_tilemap_get_id("Tiles_1"); //La capa de les colisions

fire_cooldown  = 0;

last_angle     = 0;

current_bullet = obj_Orb; 
bullet_sprite = spr_orb_yellow;


w = move_speed * 0.2;

can_pass = false

global.gameover = false
pause_show = false
global.paused = false

persistent = true


// Estat d’invulnerabilitat
invincible        = false;
invincible_time   = 1.0;    // segons d’immunitat després de rebre dany
blink_interval    = 0.1;    // temps entre parpellejos
blink_timer       = 0;