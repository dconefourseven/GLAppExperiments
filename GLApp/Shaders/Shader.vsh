//
//  Shader.vsh
//  GLApp
//
//  Created by David Clarke on 05/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform vec2 translate;

mat4 leftOrthoMatrix = mat4( 2.0/480.0, 0.0, 0.0, -1.0,
                             0.0, 2.0/-320.0, 0.0, 1.0,
                             0.0, 0.0, 1.0, 0.0,
                             0.0, 0.0, 0.0, 1.0); 

const float Angle = 3.14/2.0;

mat4 RotationMatrix = mat4( cos( Angle ), -sin( Angle ), 0.0, 0.0,
                           sin( Angle ),  cos( Angle ), 0.0, 0.0,
                           0.0,           0.0, 1.0, 0.0,
                           0.0,           0.0, 0.0, 1.0 );

uniform int orientation;

void main()
{
    
    gl_Position = position;
    
    gl_Position.x += translate.x;
    gl_Position.y += translate.y;
    
    gl_Position *= leftOrthoMatrix;
    
    

    colorVarying = color;
}
