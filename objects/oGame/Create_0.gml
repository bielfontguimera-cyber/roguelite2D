global.MAP_W = 9;  // pots canviar-ho
global.MAP_H = 9;
map_generate();
build_current_room();


global.ITEM_POOL = [
    obj_PickUp_Damage,   // el que puja +1 dany
    obj_PickUp_Hp,    // posa aquí el teu segon pickup (canvia el nom si cal)
    obj_PickUp_BSpeed,
    obj_PickUp_Speed
];

global.ENEMY_POOL = [
    obj_Slime2,   // el que puja +1 dany
    obj_Enemi,
    obj_Shooter,
        // posa aquí el teu segon pickup (canvia el nom si cal)
];




if (!variable_global_exists("floor")) {
    global.floor = 1;                  // només la 1a vegada d’una run
}