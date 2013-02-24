// POV-Ray 3.6 Scene File "slocvala.pov"
// Author: Marcec Mario, 2013

// email:  <mario.marce42@googlmail.com>
// orginal tutorial :homepage: http://wwww.f-lohmueller.de
//
//povray slocvala.pov +H320 +V320
//size changed with imagemagic.
//------------------------------------------------------------------------
#version 3.6;
global_settings{ assumed_gamma 1.0 }
//------------------------------------------------------------------------
#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "metals.inc"
#include "golds.inc"
#include "stones.inc"
#include "woods.inc"
#include "shapes.inc"
#include "shapes2.inc"
#include "functions.inc"
#include "math.inc"          
#include "transforms.inc"
//------------------------------------------------------------------------
#declare Camera_0 = camera {                                 // xy-view
                             angle 20
                             location  <0.0 , 0.0 ,-38.0>
                             right     x*image_width/image_height
                             look_at   <0.0 , 0.0 , 0.0>
                           }

#declare Camera_1 = camera {                                // diagonal view
                             angle 17
                             location  <20.0 , 20.0 ,-20.0>
                             right     x*image_width/image_height
                             look_at   <0.5 , 1 , 0.0>
                           }
#declare Camera_2 = camera {                               // yz-view
                             angle 20          
                             location  <31.0 , 7.0 ,1.0>
                             right     x*image_width/image_height
                             look_at   <1.5 , 1.4 , 1.0>
                           }
#declare Camera_3 = camera { 
                             
							location <2, 1, -4.75>
						    look_at <1.6,0.85,0>
						    angle 35
                           }

camera{Camera_3}

//------------------------------------------------------------------------
// sun -------------------------------------------------------------------
light_source{<1500,2500,-2500> color White}
// sky -------------------------------------------------------------------
sky_sphere{ pigment{ gradient <0,1,0>
                     color_map{ [0   color rgb<1,1,1>         ]//White
                                [0.4 color rgb<1,1,1>]//~Navy
                                [0.6 color rgb<1,1,1>]//<0.14,0.14,0.56>]//~Navy
                                [1.0 color rgb<1,1,1>         ]//White
                              }
                     scale 2 }
           } // end of sky_sphere 
//---------------------------- objects in scene ----------------------------
//--------------------------------------------------------------------------
#default{ finish {ambient 0.15 diffuse 0.85} } // 

sphere {< 4,0,-1>, 1 texture{pigment{color Red}finish{ reflection 1 }} }

//-----------------------------------------------------------------------------------
sphere{ <0,0,0>, 5 translate<1,0,7>
        texture{ Gold_Nugget   }        
      }
 
 text {
    ttf "timrom.ttf" "V" 1, 0
    pigment { Blue }
    scale<3,2.5,1>
  }
  text {
    ttf "timrom.ttf" "++" 1, 0
    pigment { Cyan }
    scale<1,1.5,1>
	translate<2,1,0>
  }
  text {
    ttf "timrom.ttf" "ala" 1, 0
    pigment { Blue }
    scale<0.75,1.5,1>
	translate<1.5,0,0>
  }
// ------------------------------------------------------------------------------------------------------- end
