//
//  GameScreen.h
//  GLApp
//
//  Created by David Clarke on 30/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <OpenGLES/EAGL.h>

#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

// Uniform index.
enum {
    UNIFORM_TRANSLATE,
    UNIFORM_ORIENTATION,
    UNIFORM_SCALE,
    UNIFORM_SAMPLER,
    NUM_UNIFORMS
};

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_TEXTURE,
    NUM_ATTRIBUTES
};

@interface GameScreen : NSObject
{
    GLuint program;
    
    GLint uniforms[NUM_UNIFORMS];
}

-(void)LoadContent;
-(void)Update;
-(void)Draw;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

@end
