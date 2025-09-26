/// oEnemy – Draw
draw_self();

var bar_w = sprite_width * 0.8;
var bar_h = 4;
var bx = x ;
var by = y -20; // 12 píxels per sobre

var perc_e = hp / hp_max;
var bw_now = bar_w * perc_e;

// fons
draw_set_color(c_black);
draw_rectangle(bx-1, by-1, bx + bar_w+1, by + bar_h+1, false);

// barra de vida
draw_set_color(c_red);
draw_rectangle(bx, by, bx + bw_now, by + bar_h, false);

// contorn
draw_set_color(c_white);
draw_rectangle(bx, by, bx + bar_w, by + bar_h, true);