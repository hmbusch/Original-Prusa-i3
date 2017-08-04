// PRUSA iteration3
// X end idler
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

module x_end_idler_holes(vrod_distance, lead_screw) {
    x_end_holes(vrod_distance, lead_screw);
    
    // Holes for pulley axle
    translate([0,3.5,0]) {
        translate(v=[0,-22,30.25]) rotate(a=[0,-90,0]) cylinder(h = 80, r=1.8, $fn=30);
        translate(v=[1.5,-22,30.25]) rotate(a=[0,-90,0]) cylinder(h = 10, r=3.1, $fn=30);
        translate(v=[-21.5,-22,30.25]) rotate(a=[0,-90,0]) rotate(a=[0,0,30]) cylinder(h = 80, r=3.2, $fn=6);
    }
}

module waste_pocket() {
    // waste pocket
    translate([-15,12,6]) rotate([90,0,0]) cylinder( h=5, r=5.5, $fn=30);     
    translate([-15,12,51]) rotate([90,0,0]) cylinder( h=5, r=5.5, $fn=30);    
    translate([-15,7.1,6]) rotate([90,0,0]) cylinder( h=3, r1=5.5, r2=4.3, $fn=30);     
    translate([-15,7.1,51]) rotate([90,0,0]) cylinder( h=3, r=5.5, r2=4.3, $fn=30);      
    
    //M3 thread
    translate([-15,21.5,6]) rotate([90,0,0]) cylinder( h=12, r=1.7, $fn=30); 
    translate([-15,21.5,51]) rotate([90,0,0]) cylinder( h=12, r=1.7, $fn=30); 

    //M3 heads
    translate([-15,24.5,6]) rotate([90,0,0]) cylinder( h=4, r=3, $fn=30); 
    translate([-15,24.5,51]) rotate([90,0,0]) cylinder( h=4, r=3, $fn=30); 

    //M3 nut traps
    translate([-17.9,13.5,52-3-1.6]) cube([6,3,20]);
    translate([-17.9,13.5,-10+1.5+1.6]) cube([6,3,16]);
}


module x_end_idler_base(vrod_distance, lead_screw, add_size) {
    union() {
        difference() {
            union() {
                x_end_base(vrod_distance, lead_screw);
                translate([-23.5, 10.5, 0]) cube([17, 13, 58]);
            }
            x_end_idler_holes(vrod_distance, lead_screw);
            translate([0, 13, 0]) x_end_belt_hole(add_size);
            translate([0, 13, 0]) x_end_pushrod_holes(add_size);
            
        }
        translate([-15,22.5,6]) rotate([90,0,0]) cylinder( h=13, r=6, $fn=30);
        translate([-15,22.5,51]) rotate([90,0,0]) cylinder( h=13, r=6, $fn=30);
    }
}

module selective_infill(add_size) mirror([0,1,0]) translate([-50, -33, 0.6]) { 
    
    difference() {
        // selective infill for TR nut ring
        union() {
            difference() {
                #translate([50,50 + add_size,0.6]) rotate([0,0,90]) cylinder( h=6, r=11.7, $fn=30);//0, 17, 0.6
                #translate([50,50 + add_size,-1]) rotate([0,0,90]) cylinder( h=10, r=11.5, $fn=30);
            }
            difference() {
                translate([50,50 + add_size,0.6]) rotate([0,0,90]) cylinder( h=6, r=10.7, $fn=30); //0, 17, 0.6
                translate([50,50 + add_size,-1]) rotate([0,0,90]) cylinder( h=10, r=10.5, $fn=30);
            } 
            difference() {
                translate([50,50 + add_size,0.6]) rotate([0,0,90]) cylinder( h=6, r=9.9, $fn=30); //0, 17, 0.6
                translate([50,50 + add_size,-1]) rotate([0,0,90]) cylinder( h=10, r=9.7, $fn=30);
            } 
            difference() {
                translate([50,50 + add_size,0.6]) rotate([0,0,90]) cylinder( h=6, r=9, $fn=30); //0, 17, 0.6
                translate([50,50 + add_size,-1]) rotate([0,0,90]) cylinder( h=10, r=8.8, $fn=30);
            } 
        }
        
        // prevent nut traps and main body from being sliced up for reinforcements
        translate([57.5,50.5 + add_size,-1]) rotate([0,0,45]) cube([8,10,9]);                         // front         
        translate([51 - (add_size/10), 31.5 + add_size * 0.75,-1]) rotate([0,0,45]) cube([10,20,20]); // front angled   
        translate([32,37.5,-1]) cube([8,30,9]);                                                       // inner horizontal 
    }
} 
    
   
module reinforcement_selective_infill(add_size) {
    
    rotate([90,0,-15,]) translate ([-1.5 + (add_size/15), 8, 26 + add_size])linear_extrude(height = 0.2) polygon( points=[[-2,0],[0,12],[8,0]] ); // bearings
    rotate([90,0,-50,]) translate ([8.5, 8, 1.4 + (add_size * 0.65)])linear_extrude(height = 0.2) polygon( points=[[0,0],[0,12],[8 + add_size/2,0]] ); //body    
}
    
module x_end_idler(vrod_distance = 17, lead_screw = true) {
    // additional size due to larger vrod_distance
    add_size = vrod_distance - base_vrod_distance;
    
    mirror([0,1,0]) 
    difference() {
        x_end_idler_base(vrod_distance, lead_screw, add_size);
        waste_pocket();
        
        // Selective infill is only needed when we have a lead screw
        if (lead_screw) {
            selective_infill(add_size);
            reinforcement_selective_infill(add_size);
        }
    }
}

x_end_idler(vrod_distance = 22, lead_screw = false);


