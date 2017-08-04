// PRUSA iteration3
// X end motor
// Adapted for use in the AM8 conversion
// GNU GPL v3
// Josef Průša <iam@josefprusa.cz> and contributors
// http://www.reprap.org/wiki/Prusa_Mendel
// http://prusamendel.org
// https://www.thingiverse.com/thing:2263216

use <x-end.scad>

// The distance between the vertical rods that this part 
// was originally designed for. DO NOT EDIT THIS VALUE.
// If you want to increase the spacing of the verticals rods,
// pass another value to vrod_distance when calling x_end_idler().
base_vrod_distance = 17;

module x_end_motor_base(vrod_distance, lead_screw) {
    x_end_base(vrod_distance, lead_screw);
    translate(v=[-15,31,26.5]) cube(size = [17,44,53], center = true);
}

module x_end_motor_holes(vrod_distance, lead_screw) {
    
    x_end_holes(vrod_distance, lead_screw);
    
    // Position to place
    translate(v=[-1,32,30.25]) {
        // Belt hole
        translate(v=[-14,1,0]) cube(size = [10,46,22], center = true);
        
        // Motor mounting holes
        translate(v=[20,-15.5,-15.5]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 70, r=1.8, $fn=30);       
        translate(v=[1,-15.5,-15.5]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 10, r=3.1, $fn=30);
        translate(v=[20,-15.5,15.5]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 70, r=1.8, $fn=30);
        translate(v=[1,-15.5,15.5]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 10, r=3.1, $fn=30);
        translate(v=[20,15.5,-15.5]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 70, r=1.8, $fn=30);
        translate(v=[1,15.5,-15.5]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 10, r=3.1, $fn=30);
        translate(v=[20,15.5,15.5]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 70, r=1.8, $fn=30);
        translate(v=[1,15.5,15.5]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 10, r=3.1, $fn=30);

        // Holes for dampener prongs
        translate(v=[-21,8.5,-15.5]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 40, r=1.2, $fn=30);
        translate(v=[-21,-8.5,15.5]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 40, r=1.2, $fn=30);

        // Material saving cutout 
        translate(v=[-10,12,10]) cube(size = [60,42,42], center = true);

        // Material saving cutout
        translate(v=[-10,40,-30]) rotate(a=[45,0,0])  cube(size = [60,42,42], center = true);
    }
}

// Motor shaft cutout
module x_end_motor_shaft_cutout() {
    union() {
        difference() {
            translate(v=[0,32,30]) rotate(a=[0,-90,0]) rotate(a=[0,0,90]) cylinder(h = 70, r=17, $fn=6);
           
            translate(v=[-10,-17+32,30]) cube(size = [60,2,10], center = true);
            translate(v=[-10,-8+32,-15.5+30]) rotate(a=[60,0,0]) cube(size = [60,2,10], center = true); 
            translate(v=[-10,8+32,-15.5+30]) rotate(a=[-60,0,0]) cube(size = [60,2,10], center = true);
        }
    
        translate(v=[-30,25.2,-11.8 +30]) rotate(a=[0,90,0]) cylinder(h = 30, r=3, $fn=30);
        translate(v=[-30,19.05,30]) rotate(a=[0,90,0]) cylinder(h = 30, r=3.5, $fn=100);
    }
}
 
// Final part
module x_end_motor(vrod_distance = 17, lead_screw = true) {
    // additional size due to larger vrod_distance
    add_size = vrod_distance - base_vrod_distance;
    
    difference() {
        x_end_motor_base(vrod_distance, lead_screw);
        x_end_motor_shaft_cutout();
        x_end_motor_holes(vrod_distance, lead_screw);
        
        translate([-15,8.5,6]) rotate([90,0,0]) cylinder(h=5, r=5, $fn=30);   
        translate([-15,8.5,51]) rotate([90,0,0]) cylinder(h=5, r=5, $fn=30);   
        translate([-15,3.5,6]) rotate([90,0,0]) cylinder(h=3, r1=5, r2=4, $fn=30);   
        translate([-15,3.5,51]) rotate([90,0,0]) cylinder(h=3, r1=5, r2=4, $fn=30); 
    }
}

x_end_motor(vrod_distance = 22, lead_screw = false);