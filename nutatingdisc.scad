disc_d=20; // internal disc diameter
disc_t=0.25; // disc thickness
ball_d=10; // ball diameter

module nutating_disc()
{
union()
{
  difference()
  {
    cylinder(d=disc_d,h=disc_t,,$fn=50,center=true);
    // the slit
    translate([disc_d/2,0,0])
    cube([disc_d,disc_t,disc_t+0.001],center=true);
  }
  sphere(d=ball_d,$fn=50,center=true);
}
}


// nutating angle amplitude
nutating_amplitude=20; // degrees
// nutating animation
xr=cos(360*$t);
yr=sin(360*$t);

// the planar circle touching disc edge
touching_d=disc_d*cos(nutating_amplitude);
touching_h=disc_d/2*sin(nutating_amplitude);
touching_t=0.25; // mm thickness of touching disck

translate([0,0,touching_h])
  cylinder(d=touching_d,h=touching_t,center=true);
translate([0,0,-touching_h])
  cylinder(d=touching_d,h=0.1,center=true);

rotate([nutating_amplitude*xr,nutating_amplitude*yr,0])
  nutating_disc();