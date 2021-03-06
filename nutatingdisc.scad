disc_d=25; // mm nutating disc diameter
disc_t=1.0; // mm disc thickness
divider_wall_t=1.0; // mm the cavity divider wall thickness
ball_d=disc_d/2; // mm internal ball diameter
pin_d=2; // mm transmission pin diameter
pin_h=5; // mm pin length

iolet_h=5;
iolet_w=5;
iolet_angle=15;

clearance=0.2; // mm smaller=thight, larger=loose

cavity_t=1.0; // mm cavity shell thickness

// nutating angle amplitude
nutating_amplitude=15; // degrees

opening_d=sin(nutating_amplitude)*(ball_d+2*clearance+cavity_t)+pin_d+2*clearance;

// the planar circle touching disc edge
touching_d=disc_d*cos(nutating_amplitude);
touching_h=disc_d/2*sin(nutating_amplitude);
ball_h=ball_d/2*sin(nutating_amplitude); // height of disc near the inner ball

// diameter of internal cavity
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
      cube([disc_d,divider_wall_t+2*clearance,divider_wall_t+2*clearance],center=true);
    }
    sphere(d=ball_d,$fn=50,center=true);
    cylinder(d=pin_d,h=ball_d/2+pin_h,$fn=50);
  }
}

module cavity()
{
  intersection()
  {
    // barrel shaped cavity
    difference()
    {
      union()
      {
        // big outer sphere, drill top opening and inlet/outlet
        difference()
        {
          sphere(d=cavity_d+2*cavity_t+2*clearance,$fn=50,center=true);
          // opening for the transmission pin
          cylinder(d=opening_d,h=cavity_d,$fn=50);
          // square holes for inlet/outlet
            rotate([0,0,-iolet_angle])
              translate([cavity_d/2+cavity_t/2,0,0])
              cube([cavity_t*2,iolet_w,iolet_h],center=true);
            rotate([0,0,iolet_angle])
              translate([cavity_d/2+cavity_t/2,0,0])
              cube([cavity_t*2,iolet_w,iolet_h],center=true);
        }
      }
      union()
      {
        // cut big interior sphere limited by conuses, except the divider wall
        difference()
        {
        intersection()
        {
          // cut big sphere
          sphere(d=cavity_d+2*clearance,$fn=50,center=true);
          // cut conical nutation cavity space
          difference()
          {
            cube([cavity_d*2,cavity_d*2,2*touching_h+2*clearance],center=true);
            union()
            {
              // upper cone
              translate([0,0,touching_h/2+disc_t/4])
                cylinder(d1=0,d2=cavity_d,
            h=touching_h+disc_t/2,$fn=50,center=true);
              // lower cone
              translate([0,0,-touching_h/2-disc_t/4])
                cylinder(d2=0,d1=cavity_d,
            h=touching_h+disc_t/2,$fn=50,center=true);
            }
          }
        }
          // leave divider wall uncut
          translate([cavity_d/2,0,0])
            cube([
              cavity_d,
              divider_wall_t+0.001,
              touching_h*2+clearance*2+0.001],
              center=true);
        }
        // cut small inner sphere
        sphere(d=ball_d+2*clearance,$fn=50,center=true);

      }
    }
    union()
    {
      // intersection: reduce outside extra material
      if(0)
      cube([cavity_d*2,cavity_d*2,2*touching_h+2*clearance+2*cavity_t],center=true);
      // intersection reduce outside
      // extra material, easier printing
      // leave extra material down
      extra_down=ball_d/4;
      if(1)
      translate([0,0,-extra_down/2])
      cube([cavity_d*2,cavity_d*2,ball_d*0+2*touching_h+2*clearance+2*cavity_t+extra_down],center=true);
      // reduce material for inner sphere
      sphere(d=ball_d+2*cavity_t+2*clearance,$fn=50,center=true);
    }
  }
}


// nutating animation
xr=cos(360*$t);
yr=sin(360*$t);

// for nutation animation
if(1)
{
  if(1)
  color([0.2,1.0,1.0],alpha=0.2)
    difference()
    {
      cavity();
      translate([50,50,50])
        cube([100,100,100],center=true);
    }
  if(1)
  color([1.0,0.2,1.0],alpha=0.60)
    rotate([nutating_amplitude*xr,nutating_amplitude*yr,0])
      nutating_disc();
}


// attempt for printing
// nutating disc is not FDM printable
// its layers will fall
if(0)
{
    difference()
    {
      union()
      {
        cavity();
        nutating_disc();
      }
      translate([0,0,-ball_d+clearance+cavity_t])
        cube([2*cavity_d,2*cavity_d,ball_d],center=true);
    }
}
