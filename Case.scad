// Case configuration
wall_width = 2;  // width of walls
bottom_thickness = 5;  // thickness of bottom
inside_extra_space = 1;  // extra space inside
mounting_holes_diameter = 3 + 0.5;  // diameter for mounting holes
mounting_tabs_width = 3;  // additional tab space around the frame holes
rumba_mount_width = 2.2;  // additional space around the rumba holes
screw_head_diameter = 5.4 + 0.5;
screw_head_height = 3 + 0.5;
write_text = true;
text_thickness = 0.4;
text_height = 2.8;
text_spacing = 1;
text_letter_spacing = 1.17;
text_font = "Letters.dxf";

// Uncomment for RUMBA
inside_dimensions = [135, 75, 35];
pcb_thickness = 1.5;
pcb_mount_height = 2.2;
pcb_holes_diameter = 3 + 0.5;
pcb_mount_diameter = pcb_holes_diameter + 4;
pcb_hole_positions = [[3.5, 3.5],
                      [inside_dimensions[0] - 3.5, 3.5],
                      [inside_dimensions[0] - 3.5, 3.5 + 35],
                      [3.5, inside_dimensions[1] - 3.5]];
pcb_connectors = [["HE0", "front", "cube", [33.1, 0, 0], 9.2, 6],  //name, side, kind, position, length, height
                  ["HE1", "front", "cube", [43.1, 0, 0], 9.2, 6],
                  ["HE2", "front", "cube", [53.1, 0, 0], 9.2, 6],
                  ["F0", "front", "cube", [63.8, 0, 0], 6.45, 4.6],
                  ["F1", "front", "cube", [70.85, 0, 0], 6.45, 4.6],
                  ["PWR", "front", "cube", [97.4, 0, 0], 9.2, 6],
                  ["HB-P", "front", "cube", [107.4, 0, 0], 9.2, 6],
                  ["HB-O", "front", "cube", [117.4, 0, 0], 9.2, 6],
                  ["USB", "left", "cube", [0, 9, -0.5], 10, 5],
                  ["TEMPERATURES", "left", "cube", [0, 21.6, 10.5], 26, 3.5],
                  ["ENDSTOPS", "left", "cube", [0, 51.4, 10.5], 16, 3.5],
                  [undef, "back", "cube", [44.4, 0, 0], 14, 4.6],
                  [undef, "back", "cube", [59.5, 0, 0], 14, 4.6],
                  [undef, "back", "cube", [74.6, 0, 0], 14, 4.6],
                  [undef, "back", "cube", [89.7, 0, 0], 14, 4.6],
                  [undef, "back", "cube", [104.8, 0, 0], 14, 4.6],
                  [undef, "back", "cube", [119.9, 0, 0], 14, 4.6],
                  ["X", "back", "cube", [46, 0, 9.2], 10.8, 3.5],
                  ["Y", "back", "cube", [61.1, 0, 9.2], 10.8, 3.5],
                  ["Z", "back", "cube", [76.2, 0, 9.2], 10.8, 3.5],
                  ["E0", "back", "cube", [91.3, 0, 9.2], 10.8, 3.5],
                  ["E1", "back", "cube", [106.4, 0, 9.2], 10.8, 3.5],
                  ["E2", "back", "cube", [121.5, 0, 9.2], 10.8, 3.5]];

use <Write/Write.scad>

main();

// Main
module main() {
    difference() {
        union() {
            // Case
            case(inside_dimensions, wall_width, bottom_thickness);

            // PCB mounts
            translate([wall_width + inside_extra_space, wall_width + inside_extra_space, bottom_thickness])
                pcb_mounts(pcb_hole_positions, pcb_mount_height, pcb_mount_diameter);
        }

        // PCB holes
        translate([wall_width + inside_extra_space, wall_width + inside_extra_space, 0])
            pcb_holes(pcb_hole_positions, bottom_thickness + pcb_mount_height, pcb_holes_diameter);

        // PCB connectors
        translate([0, 0, bottom_thickness + pcb_mount_height + pcb_thickness]) {
            for (pcb_connector = pcb_connectors) {
                if (pcb_connector[1] == "front") {
                    translate([wall_width + inside_extra_space, 0, 0] + pcb_connector[3])
                    if (pcb_connector[2] == "cube") {
                        cube([pcb_connector[4], wall_width, pcb_connector[5]]);
                    } else if (pcb_connector[2] == "cylinder") {
                        rotate([90, 0, 0]) cylinder(h=2, r=pcb_connector[4]);
                    }
                } else if (pcb_connector[1] == "left") {
                    translate([0, wall_width + inside_extra_space, 0] + pcb_connector[3])
                    if (pcb_connector[2] == "cube") {
                        cube([wall_width, pcb_connector[4], pcb_connector[5]]);
                    } else if (pcb_connector[2] == "cylinder") {
                        rotate([90, 90, 0]) cylinder(h=2, r=pcb_connector[4]);
                    }
                } else if (pcb_connector[1] == "back") {
                    translate([wall_width + inside_extra_space, wall_width + 2 * inside_extra_space + inside_dimensions[1], 0] + pcb_connector[3])
                    if (pcb_connector[2] == "cube") {
                        cube([pcb_connector[4], wall_width, pcb_connector[5]]);
                    } else if (pcb_connector[2] == "cylinder") {
                        rotate([90, 90, 0]) cylinder(h=2, r=pcb_connector[4]);
                    }
                }
            }
        }

        // PCB connector text
        translate([0, 0, bottom_thickness + pcb_mount_height + pcb_thickness]) {
            for (pcb_connector = pcb_connectors) {
                if (write_text && pcb_connector[0] != undef && pcb_connector != "") {
                    if (pcb_connector[1] == "front") {
                        translate([wall_width + inside_extra_space + pcb_connector[4] / 2, text_thickness / 2, pcb_connector[5] + text_height / 2 + text_spacing] + pcb_connector[3])
                        rotate([90, 0, 0])
                            write(pcb_connector[0], t=text_thickness, h=text_height, center=true, font=text_font, space=text_letter_spacing);
                    } else if (pcb_connector[1] == "left") {
                        translate([text_thickness / 2, wall_width + inside_extra_space + pcb_connector[4] / 2, pcb_connector[5] + text_height / 2 + text_spacing] + pcb_connector[3])
                        rotate([90, 0, -90])
                            write(pcb_connector[0], t=text_thickness, h=text_height, center=true, font=text_font, space=text_letter_spacing);
                    } else if (pcb_connector[1] == "back") {
                        translate([wall_width + inside_extra_space + pcb_connector[4] / 2, 2 * (wall_width + inside_extra_space) + inside_dimensions[1] - text_thickness / 2, pcb_connector[5] + text_height / 2 + text_spacing] + pcb_connector[3])
                        rotate([90, 0, 180])
                            write(pcb_connector[0], t=text_thickness, h=text_height, center=true, font=text_font, space=text_letter_spacing);
                    }
                }
            }
        }
    }
}


module case(inside, wall_width, bottom_thickness, inside_extra_space=1) {
    difference() {
        cube([inside[0] + 2 * (inside_extra_space + wall_width),
              inside[1] + 2 * (inside_extra_space + wall_width),
              inside[2]]);
        translate([wall_width, wall_width, bottom_thickness])
            cube([inside[0] + 2 * inside_extra_space,
                  inside[1] + 2 * inside_extra_space,
                  inside[2] - bottom_thickness]);
    }
}

module pcb_mounts(positions, height, diameter) {
    for (position = positions) {
        translate(position)
            cylinder(h=height, r=diameter/2, $fn=50);
    }
}

module pcb_holes(positions, height, diameter) {
    for (position = positions) {
        translate(position)
            cylinder(h=height, r=diameter/2, $fn=50);
    }
}
