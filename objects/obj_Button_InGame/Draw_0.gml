draw_self();

var rx1 = x - w * 0.5;
var ry1 = y - h * 0.5;
var rx2 = x + w * 0.5;
var ry2 = y + h * 0.5;

draw_set_alpha(1);
draw_set_color(hovered ? make_color_rgb(80,80,120) : make_color_rgb(50,50,80));
draw_rectangle(rx1, ry1, rx2, ry2, false);


draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_2);
draw_text((rx1+rx2)*0.5, (ry1+ry2)*0.5, string(text));
