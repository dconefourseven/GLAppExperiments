//
//  Shader.vsh
//  GLApp
//
//  Created by David Clarke on 05/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
//attribute vec4 color;

varying vec4 colorVarying;

uniform vec2 translate;
uniform vec2 scale;

mat4 OrthoMatrix = mat4(        2.0/480.0, 0.0, 0.0, -1.0,
                                0.0, 2.0/-320.0, 0.0, 1.0,
                                0.0, 0.0, 1.0, 0.0,
                                0.0, 0.0, 0.0, 1.0); 

mat4 iPadOrthoMatrix = mat4(    2.0/1024.0, 0.0, 0.0, -1.0,
                                0.0, 2.0/-768.0, 0.0, 1.0,
                                0.0, 0.0, 1.0, 0.0,
                                0.0, 0.0, 0.0, 1.0); 

attribute vec2 a_texCoord;
varying vec2 v_texCoord;

void main()
{ 
    gl_Position = position;
    
    gl_Position.x *= scale.x;
    gl_Position.y *= scale.y;
    
    gl_Position.x += translate.x;
    gl_Position.y += translate.y;
    
    gl_Position *= OrthoMatrix;

    v_texCoord = a_texCoord;
    //colorVarying = color;
}
