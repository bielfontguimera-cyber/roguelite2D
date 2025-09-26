var _hor = clamp(target_x - x, -1, 1);
var _ver = clamp(target_y - y, -1, 1);

move_and_collide(_hor * move_speed, _ver * move_speed, [tilemap, obj_Enemies]);

if (can_pass){
    solid = false
} else { solid = true}
    


if (hp <= 0) {
  
    instance_destroy(); // elimina el boss
}