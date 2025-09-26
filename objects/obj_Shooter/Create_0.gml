image_speed = 0;

hp = hp_max

shoot_rate      = 90;      // frames entre trets (45≈0.75s a 60fps)
shoot_cooldown  = irandom(shoot_rate-1); // desincronitza
range           = 220;     // abast de visió
los_blocker     = oWall; // objecte que bloqueja línia de visió (canvia-ho)

facing = 0; // 0=up, 1=right, 2=down, 3=left
sprs   = [ spr_Shooter_Up, spr_Shooter_right, spr_Shooter_Down, spr_Shooter_left ];
sprite_index = sprs[facing];