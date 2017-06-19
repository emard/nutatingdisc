disc_d=20; // internal disc diameter
disc_t=0.25; // disc thickness
ball_d=10; // ball diameter

cavity_t=0.5; // cavity thickness

// nutating angle amplitude
nutating_amplitude=20; // degrees

// the planar circle touching disc edge
touching_d=disc_d*cos(nutating_amplitude);
touching_h=disc_d/2*sin(nutating_amplitude);
touching_t=0.25; // mm thickness of touching disck

cavity_d=2*sqrt((touching_d/2)*(touching_d/2)+touching_h*touching_h);

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

module cavity()
{
  union()
  {
    // barrel shaped cavity
  difference()
  {
    union()
    {
      // outer sphere
      sphere(d=cavity_d+2*cavity_t,$fn=50,center=true);
    }
    union()
    {
      // cut interior
      sphere(d=cavity_d,$fn=50,center=true);
      // cut plane above
      translate([0,0,cavity_d/2+touching_h])
        cube([cavity_d,cavity_d,cavity_d],center=true);
      // cut plane below
      translate([0,0,-cavity_d/2-touching_h])
        cube([cavity_d,cavity_d,cavity_d],center=true);

    }

  }

  difference()
  {
    // inner ball shell
    sphere(d=ball_d+2*cavity_t,$fn=50,center=true);
    union()
    {
      // cut cavity inside
        cube([cavity_d,cavity_d,2*touching_h],center=true);
    }
  }

  // upper discs with inner ball cut
  difference()
  {
    union()
    {
    // upper touching disc plate
    translate([0,0,touching_h])
      cylinder(d=touching_d+2*cavity_t,h=cavity_t,  center=true);
    // lower touching disc
    translate([0,0,-touching_h])
      cylinder(d=touching_d+2*cavity_t,h=cavity_t,  center=true);
    }
    union()
    {
      sphere(d=ball_d,$fn=50,center=true);
    }
  }     
  }    
}


// nutating animation
xr=cos(360*$t);
yr=sin(360*$t);

// upper touching disc
// union()
{

  if(1)
  color([0.2,1.0,1.0],alpha=0.2)
    difference()
    {
      cavity();
      translate([50,0,0])
        cube([100,100,100],center=true);
    }

  if(0)
  color([1.0,0.2,1.0],alpha=0.2)
    rotate([nutating_amplitude*xr,nutating_amplitude*yr,0])
      nutating_disc();
}