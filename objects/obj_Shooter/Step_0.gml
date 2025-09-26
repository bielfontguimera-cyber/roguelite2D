if (!instance_exists(obj_Player)) exit;

// dades bàsiques
var px = obj_Player.x, py = obj_Player.y;
var ang  = point_direction(x, y, px, py);
var dist = point_distance (x, y, px, py);

// tria sprite segons la direcció relativa (4 costats)
var dx = px - x, dy = py - y;
if (abs(dx) > abs(dy)) {
    facing = (dx >= 0) ? 1 : 3;   // right o left
} else {
    facing = (dy >= 0) ? 2 : 0;   // down o up
}
sprite_index = sprs[facing];

// refreda el tret
if (shoot_cooldown > 0) shoot_cooldown--;

// dispara si està a l’abast i hi ha línia de visió clara
var has_los = !collision_line(x, y, px, py, los_blocker, true, true);
if (dist <= range && has_los && shoot_cooldown <= 0) {
    var b = instance_create_layer(x, y, "Instances", obj_Shooter_Bullet);
    b.direction = ang;
    b.speed     = 2;
    b.damage    = 1;  // si vols passar dany
    shoot_cooldown = shoot_rate;
    audio_play_sound(snd_Spitting, 1, false);
}