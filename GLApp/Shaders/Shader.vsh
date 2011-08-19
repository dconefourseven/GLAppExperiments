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

uniform float translate;

mat4 leftOrthoMatrix = mat4( 2.0/320.0, 0.0, 0.0, -1.0,
                             0.0, 2.0/-480.0, 0.0, 1.0,
                             0.0, 0.0, 1.0, 0.0,
                             0.0, 0.0, 0.0, 1.0); 

mat4 RightOrthoMatrix = mat4( 2.0/320.0, 0.0, 0.0, -1.0,
                            0.0, 2.0/480.0, 0.0, -1.0,
                            0.0, 0.0, -1.0, 0.0,
                            0.0, 0.0, 0.0, 1.0); 

const float Angle = 3.14/2.0;

mat4 RotationMatrix = mat4( cos( Angle ), -sin( Angle ), 0.0, 0.0,
                           sin( Angle ),  cos( Angle ), 0.0, 0.0,
                           0.0,           0.0, 1.0, 0.0,
                           0.0,           0.0, 0.0, 1.0 );

uniform int orientation;

void main()
{
    leftOrthoMatrix *= RotationMatrix;
    
    gl_Position = position;
    
    
    
    //gl_Position *= RotationMatrix;
    //gl_Position.y += sin(translate) / 2.0;
    
    //gl_Position.x += 100.0;
    //gl_Position.y += 100.0;

    //if(orientation == 0)
        //gl_Position *= RightOrthoMatrix;
    //else
        gl_Position *= leftOrthoMatrix;
    
    

    colorVarying = color;
}
