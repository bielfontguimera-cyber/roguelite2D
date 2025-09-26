other.hp -= obj_Player.damage;
instance_destroy();

if (other.hp <= 0) {
    with (other) instance_destroy(); 
    
    var health_up = irandom_range(0,2);
    
    if (health_up = 0){
        instance_create_layer(x, y, "Instances", oHearts);
        }    
   
} 