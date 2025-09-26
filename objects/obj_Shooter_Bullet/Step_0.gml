// xoc amb murs: es destrueix
if (place_meeting(x, y, oWall)) {
    instance_destroy();
    exit;
}

// fora de room: elimina
if (x < 0 || x > room_width || y < 0 || y > room_height) {
    instance_destroy();
    exit;
}

// col·lisió amb el jugador
var p = instance_place(x, y, obj_Player);
if (p != noone) {
    with (p) hp -= (other.damage ?? 1); // usa damage si existeix
    instance_destroy();
}