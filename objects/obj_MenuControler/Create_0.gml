var gw = display_get_gui_width();
var gh = display_get_gui_height();

var cx = gw * 0.5;
var cy = gh * 0.5;

var labels = ["Jugar","Opcions","Controls","Crèdits","Sortir"];
var actions = [0, 1, 2, 3, 4, 5, ];

var spacing = 40;

// centra tots els botons respecte el centre vertical
for (var i = 0; i < array_length(labels); i++) {
    var yy = cy - (array_length(labels) * spacing * 0.5) + i * spacing;
    var b = instance_create_layer(cx, yy, "Instances", obj_Button_Menu);
    b.text   = labels[i];
    b.action = actions[i];
}

