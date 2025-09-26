

if (!minimap_show) exit;
    

var W = global.MAP_W;
var H = global.MAP_H;

var mm_w = MM_PAD*2 + W*(MM_CELL+MM_GAP) - MM_GAP;
var mm_h = MM_PAD*2 + H*(MM_CELL+MM_GAP) - MM_GAP;

// fons + marc
draw_set_alpha(0.9);
draw_set_color(COL_BG);
draw_rectangle(MM_X, MM_Y, MM_X+mm_w, MM_Y+mm_h, false);

draw_set_alpha(1);
draw_set_color(COL_FRAME);
draw_rectangle(MM_X, MM_Y, MM_X+mm_w, MM_Y+mm_h, true);

// sales
for (var yy = 0; yy < H; yy++) {
    for (var xx = 0; xx < W; xx++) {
        var R = global.room_grid[room_index(xx,yy)];
        if (is_undefined(R)) continue;

        var p  = mm_px(xx,yy);
        var x1 = p.x,             y1 = p.y;
        var x2 = x1 + MM_CELL,    y2 = y1 + MM_CELL;

        var col = COL_ROOM_OFF;
        if (R.visited) col = COL_ROOM_VIS;
        if (R.cleared) col = COL_ROOM_CLR;
        if (xx==global.curX && yy==global.curY) col = COL_ROOM_CUR;

        draw_set_color(col);
        draw_rectangle(x1, y1, x2, y2, false);

        // portes
        draw_set_color(COL_DOOR);
        var cx = (x1+x2)*0.5,     cy = (y1+y2)*0.5;
        var arm = MM_GAP + max(1, MM_CELL*0.15);
        
        
        if (R.doors.up)    draw_line(cx, y1, cx, y1 - arm);
        if (R.doors.right) draw_line(x2, cy, x2 + arm, cy);
        if (R.doors.down)  draw_line(cx, y2, cx, y2 + arm);
        if (R.doors.left)  draw_line(x1, cy, x1 - arm, cy);

        // --- marcador especial al centre (4x4) ---
        // (ho dibuixem DESPRÉS de la cel·la perquè quedi per sobre)
        if (R.type == "boss") {
            draw_set_color(c_red);
            draw_rectangle(cx-2, cy-2, cx+2, cy+2, false);
        }
        else if (R.type == "item") {
            draw_set_color(c_yellow);
            draw_rectangle(cx-2, cy-2, cx+2, cy+2, false);
        }
        else if (R.type == "shop") {
            draw_set_color(c_lime);
            draw_rectangle(cx-2, cy-2, cx+2, cy+2, false);
        }
        // -----------------------------------------
    }
}
