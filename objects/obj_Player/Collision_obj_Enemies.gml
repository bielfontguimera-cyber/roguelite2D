if (!invincible) {
    // Treure vida
   if (hp >= 0) {
        hp -= obj_Enemies.damage;
    // Activar immunitat
    invincible = true;
    alarm[1]   = room_speed * invincible_time;
    
    // Iniciar parpelleig
    blink_timer = blink_interval;
    }
}
        