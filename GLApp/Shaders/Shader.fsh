//
//  Shader.fsh
//  GLApp
//
//  Created by David Clarke on 05/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//varying lowp vec4 colorVarying;

precision mediump float;
varying vec2 v_texCoord;
uniform sampler2D s_texture; 

void main()
{
    gl_FragColor = texture2D( s_texture, v_texCoord );
    //gl_FragColor = colorVarying;
}
