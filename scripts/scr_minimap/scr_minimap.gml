#macro MM_X         1150  // posició pantalla (Draw GUI)
#macro MM_Y         26
#macro MM_CELL      14      // mida de cel·la
#macro MM_GAP       4       // separació entre cel·les
#macro MM_PAD       8       // marge interior del marc

#macro COL_BG       make_color_rgb(16,16,20)
#macro COL_FRAME    make_color_rgb(70,70,90)
#macro COL_ROOM_OFF make_color_rgb(55,55,70)    // activa però no visitada
#macro COL_ROOM_VIS make_color_rgb(110,110,150) // visitada
#macro COL_ROOM_CLR make_color_rgb(60,160,90)   // cleared
#macro COL_ROOM_CUR make_color_rgb(250,220,90)  // sala actual
#macro COL_DOOR     make_color_rgb(180,180,210)


/// helper posició pixel dins minimapa
function mm_px(xx, yy) {
    var rx = MM_X + MM_PAD + xx * (MM_CELL + MM_GAP);
    var ry = MM_Y + MM_PAD + yy * (MM_CELL + MM_GAP);
    return {x:rx, y:ry};
}