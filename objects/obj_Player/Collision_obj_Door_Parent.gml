var p = instance_place(x, y, obj_Player);{
if (p != noone && obj_Door_Parent.passable &&  ! obj_Door_Parent.locked) 
    can_pass = true
    solid = false
} 