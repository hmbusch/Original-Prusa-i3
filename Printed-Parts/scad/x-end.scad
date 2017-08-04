// PRUSA iteration3
// X end prototype
// GNU GPL v3
// Josef Průša <iam@josefprusa.cz> and contributors
// http://www.reprap.org/wiki/Prusa_Mendel
// http://prusamendel.org

use <bearing.scad>
use <polyholes.scad>

// Distance between the horizontal X-rods in millimeters
hrod_distance = 45;

// The distance between the vertical rods that this part 
// was originally designed for. DO NOT EDIT THIS VALUE.
// If you want to increase the spacing of the verticals rods,
// pass another value to vrod_distance when calling x_end_plain().
base_vrod_distance = 17;

/**
 * Creates the basic body for any X-axis end piece.
 *
 * @param vrod_distance 
 *          The spacing between the vertical smooth rod and the lead screw.
 *          The body adjusts its size, support, etc. dependent of that value.
 *          The minimal vrod_distance is 17mm, do not specify value lower than
 *          that. Also, excessively large values (> 30mm) may result in a 
 *          strange body.
 * @param lead_screw
 *          If true, a mount for the lead screw are generated. Specify false to
 *          generate a body without this, e.g. if you are using a anti-z-wobble
 *          coupling on your lead screw.
 */
module x_end_base(vrod_distance, lead_screw = true) {
    // additional size due to larger vrod_distance
    add_size = vrod_distance - base_vrod_distance;
    
    // Main block
    height = 58;
    translate(v=[-15, -9 - (add_size/2),height/2]) cube(size = [17,39 + add_size,height], center = true);

    // Bearing holder
    vertical_bearing_base();	
    
    if (lead_screw) {
        // == Nut trap ==
        // -> Cylinder
        translate(v=[0,-vrod_distance,0]) poly_cylinder(h = 8, r=12.5, $fn=25);
        
        // -> Hexagon
        translate(v=[-6,-10.6,10]) rotate([0,0,48.2]) cube(size = [10,5,1], center = true);
        
        // load relief fins
        rotate([90,0,-15,]) translate ([-1, 8, 24 + add_size])linear_extrude(height = 4) polygon( points=[[0,0],[0,12],[8,0]] ); //vzpera lozisek
        rotate([90,0,-50,]) translate ([9 - (add_size/3), 8, -0.6 + (add_size * 0.65)]) linear_extrude(height = 4) polygon( points=[[0,0],[0,12],[8 + (add_size/2),0]] ); 
        
        // Add some connecting material for larger vertical rod distances
        if (add_size >= 4) {
            translate([-3, -vrod_distance/2, 4]) cube([8, add_size, 8], center = true);
        }
    }
}

module reinforcement_selective_infill() {
    rotate([90,0,-15,]) translate ([-1.5, 8, 26])linear_extrude(height = 0.2) polygon( points=[[-2,0],[0,12],[8,0]] ); //vzpera lozisek
    
    rotate([90,0,-50,]) translate ([8.5, 8, 1.4])linear_extrude(height = 0.2) polygon( points=[[0,0],[0,12],[12,0]] ); //vzpera tela    
}

module x_end_belt_hole(add_size) {
    // Belt hole
    translate(v=[-1,0,0]) {
        difference() {
            translate(v=[-5.5-10+1.5,-10 - add_size,30]) cube(size = [10,46 + 2 * add_size,28], center = true);

            // Nice edges
            translate(v=[-5.5-10+1.5-5,-10 - add_size,30+23]) rotate([0,20,0]) cube(size = [10,46 + 2 * add_size,28], center = true);
            translate(v=[-5.5-10+1.5+5,-10 - add_size,30+23]) rotate([0,-20,0]) cube(size = [10,46 + 2 * add_size,28], center = true);
            translate(v=[-5.5-10+1.5,-10 - add_size,30-23]) rotate([0,45,0]) cube(size = [10,46 + 2 * add_size,28], center = true);
            translate(v=[-5.5-10+1.5,-10 - add_size,30-23]) rotate([0,-45,0]) cube(size = [10,46 + 2 * add_size,28], center = true);

        }
    }
}

module x_end_pushrod_holes(add_size) {
    // Bottom pushfit rod
    translate(v=[-15,-41 - add_size,6]) rotate(a=[-90,0,0]) pushfit_rod(7.8,50 + add_size);
    // Top pushfit rod
    translate(v=[-15,-41.5 - add_size,hrod_distance+6]) rotate(a=[-90,0,0]) pushfit_rod(7.8,50 + add_size);
}

/**
 * Cuts all the neccessary holes into the base X-axis end body.
 * 
 * @param vrod_distance 
 *          The spacing between the vertical smooth rod and the lead screw.
 *          The body adjusts its size, support, etc. dependent of that value.
 *          The minimal vrod_distance is 17mm, do not specify value lower than
 *          that. Also, excessively large values (> 30mm) may result in a 
 *          strange body.
 * @param lead_screw
 *          If true, holes for mounting a trapezoidal lead screw nut are generated.
 *          Specify false if you TR nut is not attached to the X-axis ends, e.g.
 *          when using a anti-z-wobble coupling.
 */
module x_end_holes(vrod_distance, lead_screw = true) {
    // additional size due to larger vrod_distance
    add_size = vrod_distance - base_vrod_distance;
    
    vertical_bearing_holes();
    
    translate(v=[-1,0,0]) {
        // Stress relief
        translate(v=[-5.5-10+1.5,-10-1,30]) cube(size = [18,1,28], center = true);
    }

    x_end_belt_hole(add_size);

    x_end_pushrod_holes(add_size);

    if (lead_screw) {
        // == TR Nut trap ==
        // -> Hole for the nut
        translate(v=[0,-vrod_distance, -1]) poly_cylinder(h = 9.01, r = 7, $fn = 25);
        translate(v=[0,-vrod_distance, -0.1]) cylinder(h = 0.5, r1 = 6.8+0.8,r2 = 7, $fn = 25);

        // -> Screw holes for TR nut
        translate(v=[0,-vrod_distance, 0]) rotate([0, 0, -135]) translate([0, 9.5, -1]) cylinder(h = 10, r = 1.8, $fn=25);
        translate(v=[0,-vrod_distance, 0]) rotate([0, 0, -135]) translate([0, -9.5, -1]) cylinder(h = 10, r = 1.8, $fn=25);

        // -> Nut traps for TR nut screws
        translate(v=[0,-vrod_distance, 0]) rotate([0, 0, -135]) translate([0, 9.5, 6]) rotate([0, 0, 0])cylinder(h = 3, r = 3.45, $fn=6);

        translate(v=[0,-vrod_distance, 0]) rotate([0, 0, -135]) translate([0, -9.5, 6]) rotate([0, 0, 30])cylinder(h = 3, r = 3.2, $fn=6);
        translate([-5.5,-vrod_distance +0.2,6]) rotate([0,0,30]) cube([5,5,3]);
        translate([-0,-vrod_distance + 0.2,6]) rotate([0,0,60]) cube([5,10,3]);
    }
}


// Final prototype
module x_end_plain(vrod_distance = 17, lead_screw = true) {
    difference(){
        x_end_base(vrod_distance, lead_screw);
        x_end_holes(vrod_distance, lead_screw);
    }
}

x_end_plain();


module pushfit_rod(diameter,length) {
    poly_cylinder(h = length, r=diameter/2);
    difference() {
        translate(v=[0,-diameter/2.85,length/2]) rotate([0,0,45]) cube(size = [diameter/2,diameter/2,length], center = true);
        translate(v=[0,-diameter/4-diameter/2-0.4,length/2]) rotate([0,0,0]) cube(size = [diameter,diameter/2,length], center = true);
    }
 }

