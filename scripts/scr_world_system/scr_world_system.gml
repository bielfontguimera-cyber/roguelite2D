/* =================== CONSTANTS SALA =================== */
/* Coordenades de la sala amb marges */
#macro ROOM_MIN_X 192
#macro ROOM_MAX_X 630
#macro ROOM_MIN_Y 160
#macro ROOM_MAX_Y 380
#macro ROOM_CENTER_X 408
#macro ROOM_CENTER_Y 272

// coordenades on apareixen les portes
#macro DOOR_TOP_X     384
#macro DOOR_TOP_Y     112
#macro DOOR_RIGHT_X   656
#macro DOOR_RIGHT_Y   240
#macro DOOR_DOWN_X    384
#macro DOOR_DOWN_Y    400
#macro DOOR_LEFT_X    144
#macro DOOR_LEFT_Y    240


/**************** Helpers bàsics ****************/
function room_index(xx, yy) {
    return yy * global.MAP_W + xx;
}

// nombre de portes d’una sala
function room_degree(R) {
    var d = 0;
    if (R.doors.up)    d++;
    if (R.doors.right) d++;
    if (R.doors.down)  d++;
    if (R.doors.left)  d++;
    return d;
}

// activa les portes corresponents entre dues sales veïnes
function link_rooms(xx1, yy1, xx2, yy2) {
    var a = global.room_grid[room_index(xx1,yy1)];
    var b = global.room_grid[room_index(xx2,yy2)];
    if (is_undefined(a) || is_undefined(b)) return;

    if (yy2 == yy1-1 && xx2 == xx1) { a.doors.up = true;    b.doors.down = true; }
    if (xx2 == xx1+1 && yy2 == yy1) { a.doors.right = true; b.doors.left  = true; }
    if (yy2 == yy1+1 && xx2 == xx1) { a.doors.down = true;  b.doors.up    = true; }
    if (xx2 == xx1-1 && yy2 == yy1) { a.doors.left = true;  b.doors.right = true; }

    global.room_grid[room_index(xx1,yy1)] = a;
    global.room_grid[room_index(xx2,yy2)] = b;
}


/**************** Struct de Sala ****************/
function Room(_x, _y, _seed, _doors, _type) constructor {
    x           = _x;
    y           = _y;
    seed        = _seed;
    doors       = _doors;   // struct {up,right,down,left} booleans
    type        = _type;    // "start" | "normal" | "boss" | "item" | "shop"

    cleared     = false;
    visited     = false;
    spawn_done  = false;
    loot_opened = false;
    loot_spawned = false;


    post_boss_loot_spawned  = false;     // ítem del boss ja generat?
}


/**************** Helpers de generació ****************/
function manh(ax, ay, bx, by) {
    return abs(ax - bx) + abs(ay - by);
}

function dir_shuffled_biased(cx, cy, px, py, prev_dx, prev_dy, W, H) {
    var dirs = [
        {dx: 0, dy:-1, name:"up"},
        {dx: 1, dy: 0, name:"right"},
        {dx: 0, dy: 1, name:"down"},
        {dx:-1, dy: 0, name:"left"}
    ];
    var scored = array_create(4);
    for (var i = 0; i < 4; i++) {
        var d  = dirs[i];
        var nx = px + d.dx;
        var ny = py + d.dy;
        var rank = manh(nx, ny, cx, cy);
        if (d.dx == -prev_dx && d.dy == -prev_dy) rank -= 2; // penalitza backtrack
        rank += irandom(1);
        scored[i] = { d: d, r: rank };
    }
    // ordena descendent per r
    for (var a = 0; a < 4; a++)
    for (var b = a + 1; b < 4; b++)
        if (scored[b].r > scored[a].r) { var t=scored[a]; scored[a]=scored[b]; scored[b]=t; }

    var out = array_create(4);
    for (var k = 0; k < 4; k++) out[k] = scored[k].d;
    return out;
}

// Crea una leaf nova enganxada a (ax,ay) si hi ha veí buit; retorna {x,y} o undefined.
function force_leaf_next_to(ax, ay, W, H) {
    var empty = [];
    if (ay > 0    && is_undefined(global.room_grid[room_index(ax,ay-1)])) array_push(empty, {x:ax,   y:ay-1});
    if (ax < W-1  && is_undefined(global.room_grid[room_index(ax+1,ay)])) array_push(empty, {x:ax+1, y:ay  });
    if (ay < H-1  && is_undefined(global.room_grid[room_index(ax,ay+1)])) array_push(empty, {x:ax,   y:ay+1});
    if (ax > 0    && is_undefined(global.room_grid[room_index(ax-1,ay)])) array_push(empty, {x:ax-1, y:ay  });
    if (array_length(empty) == 0) return undefined;

    var pick = empty[irandom(array_length(empty)-1)];
    var Rn = new Room(pick.x, pick.y, irandom(2147483647), {up:false,right:false,down:false,left:false}, "normal");
    global.room_grid[room_index(pick.x,pick.y)] = Rn;
    link_rooms(ax, ay, pick.x, pick.y);
    return pick;
}


/**************** Generació de mapa ****************/
function map_generate(){
    randomize();

    if (is_undefined(global.MAP_W)) global.MAP_W = 9;
    if (is_undefined(global.MAP_H)) global.MAP_H = 9;
    var W = global.MAP_W, H = global.MAP_H;

    global.room_grid = array_create(W * H, undefined);

    var cx = floor(W*0.5), cy = floor(H*0.5);

    // START
    var R0 = new Room(cx, cy, irandom(2147483647), {up:false,right:false,down:false,left:false}, "start");
    R0.cleared = true; R0.spawn_done = true; R0.visited = true;
    global.room_grid[room_index(cx,cy)] = R0;

    // --- 1) TRONC PRINCIPAL (més curt) ---
    var main_len = irandom_range(4, 6);
    var spine = [{x:cx, y:cy}];

    var px = cx, py = cy;
    var pdx = 0, pdy = 0;

    for (var step=0; step<main_len; step++){
        var tried = dir_shuffled_biased(cx,cy, px,py, pdx,pdy, W,H);
        var moved = false;
        for (var i=0;i<4;i++){
            var d = tried[i];
            var nx = px + d.dx, ny = py + d.dy;
            if (nx<0 || nx>=W || ny<0 || ny>=H) continue;
            if (!is_undefined(global.room_grid[room_index(nx,ny)])) continue;

            var Rn = new Room(nx, ny, irandom(2147483647), {up:false,right:false,down:false,left:false}, "normal");
            global.room_grid[room_index(nx,ny)] = Rn;
            link_rooms(px,py, nx,ny);

            spine[array_length(spine)] = {x:nx, y:ny};
            px = nx; py = ny; pdx = d.dx; pdy = d.dy;
            moved = true; break;
        }
        if (!moved) break;
    }

    // --- 2) BRANQUES (menys i més curtes) ---
    var branch_count = clamp(irandom_range(1,2), 0, max(0, array_length(spine)-1));
    for (var b=0; b<branch_count; b++){
        var pick_i = clamp(irandom_range(1, array_length(spine)-2), 0, array_length(spine)-1);
        var sx = spine[pick_i].x, sy = spine[pick_i].y;

        var blen = irandom_range(1,2);
        var bx = sx, by = sy, bdx = 0, bdy = 0;

        for (var t=0; t<blen; t++){
            var tried2 = dir_shuffled_biased(cx,cy, bx,by, bdx,bdy, W,H);
            var moved2 = false;
            for (var j=0;j<4;j++){
                var dd = tried2[j];
                var nx2 = bx + dd.dx, ny2 = by + dd.dy;
                if (nx2<0 || nx2>=W || ny2<0 || ny2>=H) continue;
                if (!is_undefined(global.room_grid[room_index(nx2,ny2)])) continue;

                var Rb = new Room(nx2, ny2, irandom(2147483647), {up:false,right:false,down:false,left:false}, "normal");
                global.room_grid[room_index(nx2,ny2)] = Rb;
                link_rooms(bx,by, nx2,ny2);

                bx = nx2; by = ny2; bdx = dd.dx; bdy = dd.dy;
                moved2 = true; break;
            }
            if (!moved2) break;
        }
    }

    // --- 3) CAPA GRAUS 2–3 (start lliure) ---
    for (var yy=0; yy<H; yy++){
        for (var xx=0; xx<W; xx++){
            var R = global.room_grid[room_index(xx,yy)];
            if (is_undefined(R)) continue;

            if (R.type == "start"){
                if (yy>0   && !is_undefined(global.room_grid[room_index(xx,yy-1)])) link_rooms(xx,yy, xx,yy-1);
                if (xx<W-1&& !is_undefined(global.room_grid[room_index(xx+1,yy)])) link_rooms(xx,yy, xx+1,yy);
                if (yy<H-1&& !is_undefined(global.room_grid[room_index(xx,yy+1)])) link_rooms(xx,yy, xx,yy+1);
                if (xx>0   && !is_undefined(global.room_grid[room_index(xx-1,yy)])) link_rooms(xx,yy, xx-1,yy);
                continue;
            }

            var target = irandom_range(2,3);
            var pot = [];
            if (yy>0   && !is_undefined(global.room_grid[room_index(xx,yy-1)])) array_push(pot, {x:xx,   y:yy-1});
            if (xx<W-1&& !is_undefined(global.room_grid[room_index(xx+1,yy)])) array_push(pot, {x:xx+1, y:yy  });
            if (yy<H-1&& !is_undefined(global.room_grid[room_index(xx,yy+1)])) array_push(pot, {x:xx,   y:yy+1});
            if (xx>0   && !is_undefined(global.room_grid[room_index(xx-1,yy)])) array_push(pot, {x:xx-1, y:yy  });

            // shuffle ràpid
            for (var a=0;a<array_length(pot);a++){ var r=irandom(array_length(pot)-1); var tmp=pot[a]; pot[a]=pot[r]; pot[r]=tmp; }

            var deg = room_degree(R);
            for (var m=0; m<array_length(pot) && deg<target; m++){
                var vx = pot[m].x, vy = pot[m].y;
                var A = global.room_grid[room_index(xx,yy)];
                var B = global.room_grid[room_index(vx,vy)];
                if (is_undefined(A) || is_undefined(B)) continue;

                var already =
                    (vy==yy-1 && A.doors.up)    ||
                    (vx==xx+1 && A.doors.right) ||
                    (vy==yy+1 && A.doors.down)  ||
                    (vx==xx-1 && A.doors.left);
                if (already) continue;
                if (B.type!="start" && room_degree(B)>=3) continue;

                // evita 2x2 amb certa probabilitat
                var makes_square = false;
                if (vx==xx+1){
                    if (yy>0   && !is_undefined(global.room_grid[room_index(xx,yy-1)]) &&
                                 !is_undefined(global.room_grid[room_index(vx,yy-1)])) makes_square = (irandom(100)<40);
                    if (yy<H-1&& !is_undefined(global.room_grid[room_index(xx,yy+1)]) &&
                                 !is_undefined(global.room_grid[room_index(vx,yy+1)])) makes_square = makes_square || (irandom(100)<40);
                }
                if (vy==yy+1){
                    if (xx>0   && !is_undefined(global.room_grid[room_index(xx-1,yy)]) &&
                                 !is_undefined(global.room_grid[room_index(xx-1,vy)])) makes_square = makes_square || (irandom(100)<40);
                    if (xx<W-1&& !is_undefined(global.room_grid[room_index(xx+1,yy)]) &&
                                 !is_undefined(global.room_grid[room_index(xx+1,vy)])) makes_square = makes_square || (irandom(100)<40);
                }
                if (makes_square) continue;

                link_rooms(xx,yy, vx,vy);
                deg++;
            }
        }
    }

    // --- 4) ESPECIALS: fulles llunyanes + FORÇAR si falten ---
    var leaves = [];
    for (var jy=0;jy<H;jy++) for (var ix=0;ix<W;ix++){
        var RR = global.room_grid[room_index(ix,jy)];
        if (!is_undefined(RR) && RR.type=="normal" && room_degree(RR)==1){
            array_push(leaves, {x:ix, y:jy, d:manh(ix,jy,cx,cy)});
        }
    }
    // ordena per distància desc
    for (var i1=0;i1<array_length(leaves);i1++)
    for (var i2=i1+1;i2<array_length(leaves);i2++)
        if (leaves[i2].d > leaves[i1].d){ var tt=leaves[i1]; leaves[i1]=leaves[i2]; leaves[i2]=tt; }

    var placed = 0;
    if (array_length(leaves) > 0){
        var Lb = leaves[0];
        var Rb = global.room_grid[room_index(Lb.x,Lb.y)];
        Rb.type="boss"; Rb.cleared=false; Rb.spawn_done=false;
        global.room_grid[room_index(Lb.x,Lb.y)] = Rb; placed++;
    }
    if (array_length(leaves) > 1){
        var Li = leaves[1];
        var Ri = global.room_grid[room_index(Li.x,Li.y)];
        Ri.type="item"; Ri.cleared=true; Ri.spawn_done=true;
        global.room_grid[room_index(Li.x,Li.y)] = Ri; placed++;
    }
    if (array_length(leaves) > 2){
        var Ls = leaves[2];
        var Rs = global.room_grid[room_index(Ls.x,Ls.y)];
        Rs.type="shop"; Rs.cleared=true; Rs.spawn_done=true;
        global.room_grid[room_index(Ls.x,Ls.y)] = Rs; placed++;
    }

    // Fallback: si falta algun especial, crea leaf enganxada i posa’l
    var specials_order = ["boss","item","shop"];
    var tries = 0;
    while (placed < 3 && tries < 500) {
        tries++;
        var bx = irandom(W-1), by = irandom(H-1);
        var B = global.room_grid[room_index(bx,by)];
        if (is_undefined(B)) continue;
        if (B.type != "normal") continue;

        var new_leaf = force_leaf_next_to(bx, by, W, H);
        if (is_undefined(new_leaf)) continue;

        var kind = specials_order[placed];
        var Rn2  = global.room_grid[room_index(new_leaf.x, new_leaf.y)];
        Rn2.type = kind;
        if (kind == "item" || kind == "shop") { Rn2.cleared = true; Rn2.spawn_done = true; }
        global.room_grid[room_index(new_leaf.x, new_leaf.y)] = Rn2;
        placed++;
    }

    global.curX = cx; global.curY = cy;
}


/**************** Construcció de la sala actual ****************/
function build_current_room() {
    var R = global.room_grid[room_index(global.curX, global.curY)];
    if (is_undefined(R)) exit;

    // 1) neteja entitats sobrants
    with (obj_Enemies)      instance_destroy();
    with (obj_Orb)          instance_destroy();
    with (obj_Door_Parent)  instance_destroy();
    with (oTrapDoor)        instance_destroy(); 
    with (obj_Pickups)      instance_destroy(); 
    with (oHearts)      instance_destroy();

    // 2) crea portes
    var d;

    d = instance_create_layer(DOOR_TOP_X, DOOR_TOP_Y, "Instances", obj_Door_Top);
    d.passable = R.doors.up;
    d.locked   = (R.doors.up) ? !R.cleared : true;

    d = instance_create_layer(DOOR_RIGHT_X, DOOR_RIGHT_Y, "Instances", obj_Door_Right);
    d.passable = R.doors.right;
    d.locked   = (R.doors.right) ? !R.cleared : true;

    d = instance_create_layer(DOOR_DOWN_X, DOOR_DOWN_Y, "Instances", obj_Door_Bottom);
    d.passable = R.doors.down;
    d.locked   = (R.doors.down) ? !R.cleared : true;

    d = instance_create_layer(DOOR_LEFT_X, DOOR_LEFT_Y, "Instances", obj_Door_Left);
    d.passable = R.doors.left;
    d.locked   = (R.doors.left) ? !R.cleared : true;

    // 2.5) ítem de la sala d’items (una sola vegada)
    if (R.type == "item" && !R.loot_spawned) {
        room_spawn_item(R);
        R.loot_spawned = true;
    }

    // 3) Spawneja enemics si encara no ho havia fet
    if (!R.cleared && !R.spawn_done) {
        room_spawn_enemies(R);
        R.spawn_done = true;
    }

    // 3.5) Si és sala de boss cleared, crea trampilla (sempre) i ítem (una sola vegada)
    if (R.type == "boss" && R.cleared) {
        if (is_undefined(R.post_boss_loot_spawned)) R.post_boss_loot_spawned = false;

        var cx = (ROOM_MIN_X + ROOM_MAX_X) * 0.5;
        var cy = (ROOM_MIN_Y + ROOM_MAX_Y) * 0.5;

        // trampilla sempre que hi entres
        instance_create_layer(cx, cy, "Instances", oTrapDoor);

        // ítem només la primera vegada
        if (!R.post_boss_loot_spawned) {
            room_spawn_item(R);
            R.post_boss_loot_spawned = true;
        }
    }

    // 4) marca visitada i desa estat
    R.visited = true;
    global.room_grid[room_index(R.x, R.y)] = R;
}


/**************** Canvi de sala ****************/
function go_to_room(dx, dy) {
    var nx = clamp(global.curX + dx, 0, global.MAP_W - 1);
    var ny = clamp(global.curY + dy, 0, global.MAP_H - 1);
    if (is_undefined(global.room_grid[room_index(nx,ny)])) exit;

    global.curX = nx;
    global.curY = ny;
    build_current_room();
}


/**************** Spawn d’enemics ****************/
function room_spawn_enemies(R) {
    // sense enemics a start, item, shop
    if (R.type == "start" || R.type == "item" || R.type == "shop") return;

    if (R.type == "boss") {
        // Boss únic al centre
        if (instance_number(obj_Boss) == 0) {
            instance_create_layer((ROOM_MIN_X+ROOM_MAX_X)*0.5, (ROOM_MIN_Y+ROOM_MAX_Y)*0.5, "Instances", obj_Boss);
        }
        return;
    }

    // normals: en funció de la planta
    var old = random_get_seed();
    random_set_seed(R.seed);

    var num;
    if (global.floor <= 2) {
        num = irandom_range(1,3);
    } else if (global.floor <= 4) {
        num = irandom_range(2,5);
    } else {
        num = irandom_range(3,6);
    }

    repeat (num) {
        // tria un tipus aleatori de la piscina
        var c = array_length(global.ENEMY_POOL);
        if (c <= 0) break;

        var px = irandom_range(ROOM_MIN_X, ROOM_MAX_X);
        var py = irandom_range(ROOM_MIN_Y, ROOM_MAX_Y);

        var inx  = irandom(c - 1);
        var kind = global.ENEMY_POOL[inx];

        instance_create_layer(px, py, "Instances", kind);
    }

    random_set_seed(old);
}


/**************** Spawn d’ítems ****************/
function room_spawn_item(R) {
    var cx = (ROOM_MIN_X + ROOM_MAX_X) * 0.5;
    var cy = (ROOM_MIN_Y + ROOM_MAX_Y) * 0.5 + 24; // una mica per sota del centre

    var n = array_length(global.ITEM_POOL);
    if (n <= 0) return;

    var idx  = irandom(n - 1);
    var kind = global.ITEM_POOL[idx];

    instance_create_layer(cx, cy, "Instances", kind);
}


/**************** WORLD UPDATE (boss mort ⇒ trampilla + ítem + portes) ****************/
function world_update() {
    var R = global.room_grid[room_index(global.curX, global.curY)];
    if (is_undefined(R)) exit;

    // si ets a una sala de boss i NO està cleared però ja no hi ha cap boss → s’ha mort
    if (R.type == "boss" && !R.cleared) {
        if (instance_number(obj_Boss) == 0) {
            // marca estat
            R.cleared = true;
            R.spawn_done = true;

            // obre portes instanciades
            with (obj_Door_Parent) locked = false;

            // crea trampilla + ítem ara mateix
            var cx = (ROOM_MIN_X + ROOM_MAX_X) * 0.5;
            var cy = (ROOM_MIN_Y + ROOM_MAX_Y) * 0.5;

            if (instance_number(oTrapDoor) == 0) {
                instance_create_layer(cx, cy, "Instances", oTrapDoor);
            }

            if (is_undefined(R.post_boss_loot_spawned)) R.post_boss_loot_spawned = false;
            if (!R.post_boss_loot_spawned) {
                room_spawn_item(R);
                R.post_boss_loot_spawned = true;
            }

            // desa estat de sala
            global.room_grid[room_index(R.x, R.y)] = R;
        }
    }
}


function on_boss_killed_immediately() {
    // sala actual
    var idx = room_index(global.curX, global.curY);
    var R   = global.room_grid[idx];
    if (is_undefined(R)) return;
    if (R.type != "boss") return; // per seguretat

    // marca estat de sala
    R.cleared    = true;
    R.spawn_done = true;
    if (is_undefined(R.post_boss_loot_spawned)) R.post_boss_loot_spawned = false;

    // obre portes instanciades ara mateix
    with (obj_Door_Parent) locked = false;

    // crea trampilla + (opcional) ítem immediatament
    var cx = (ROOM_MIN_X + ROOM_MAX_X) * 0.5;
    var cy = (ROOM_MIN_Y + ROOM_MAX_Y) * 0.5;

    if (instance_number(oTrapDoor) == 0) {
        instance_create_layer(cx, cy, "Instances", oTrapDoor);
    }

    if (!R.post_boss_loot_spawned) {
        // Pots reutilitzar el teu helper
     
            room_spawn_item(R);
        } else {
            // fallback simple al centre una mica avall
            var n = array_length(global.ITEM_POOL);
            if (n > 0) {
                var pick = global.ITEM_POOL[ irandom(n-1) ];
                instance_create_layer(cx, cy + 24, "Instances", pick);
            }
        }
        R.post_boss_loot_spawned = true;
          global.room_grid[idx] = R;
    }

    // desa estat
  