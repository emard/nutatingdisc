disc_d=20; // internal disc diameter
disc_t=1; // disc thickness
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


nutating_amplitude=10; // degrees

xr=cos(360*$t);
yr=sin(360*$t);

rotate([nutating_amplitude*xr,nutating_amplitude*yr,0])
nutating_disc();