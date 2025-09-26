function scr_shoot(dir, bullet_type) {
    // crear
    var b = instance_create_layer(x, y, "Instances", bullet_type);

    // direcció i angle visual
    b.direction = dir;
    if (variable_instance_exists(b, "image_angle")) b.image_angle = dir;

    // velocitat de la bala: pren-la del jugador (self)
    if (variable_instance_exists(self, "bSpeed")) b.speed = self.bSpeed;

    // sprite segons el que porti el jugador
    if (variable_instance_exists(self, "bullet_sprite"))
        b.sprite_index = self.bullet_sprite;

    // so i cooldown
    audio_play_sound(snd_shoot, 1, false);
    self.fire_cooldown = self.fire_rate;

    return b;
}