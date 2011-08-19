//
//  Sprite.m
//  GLApp
//
//  Created by David Clarke on 11/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self InitSprite];
    }
    
    return self;
}

- (id)init : (NSString* const) textureName
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self InitSprite:textureName];
    }
    
    return self;
}

-(id) initWithTexture:(GLuint) spriteTexture: (GLfloat[8]) texCoords
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self InitSpriteWithTexture:texCoords];
        
        mSpriteTexture = spriteTexture;
    }
    
    return self;
}

- (void) InitSprite
{
    static const GLfloat s_squareVertices[] = { 
        -10.0f, -10.0f, 
        10.0f, -10.0f, 
        -10.0f, 10.0f, 
        10.0f,  10.0f,
    };
    
    static const GLubyte s_squareColors[] = {
        255, 0, 0, 0,
        255, 0, 0, 0,
        0, 0, 0, 0,
        0, 0, 0, 0,
    };
    
    squareColors = s_squareColors;
    squareVertices = s_squareVertices;
    
}

const GLsizeiptr vertex_size = 8*2*sizeof(GLfloat);
const GLsizeiptr texCoord_size = 8*2*sizeof(GLfloat);

- (void) InitSprite: (NSString* const) textureName
{
    [self InitTexture:textureName];
    
    static const GLfloat s_squareVertices[] = { 
        -10.0f, -10.0f, 
        10.0f, -10.0f, 
        -10.0f, 10.0f, 
        10.0f,  10.0f,
    };
        
    // Sets up an array of values for the texture coordinates.
    static const GLfloat s_spriteTexcoords[] = {
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f,
    };
    
    // Describes a box, but without a top and bottom
    GLubyte s_squareIndices[] = 
    {
        0,1,
        2,3,
    };
    
    for(int i = 0; i < 8; i++)
    {
        spriteTextureCoordinates[i] = s_spriteTexcoords[i];
    }
    
    squareVertices = s_squareVertices;
    
    // allocate a new buffer
    glGenBuffers(1, &cubeVBO);
    // bind the buffer object to use
    glBindBuffer(GL_ARRAY_BUFFER, cubeVBO);
    
    glBufferData(GL_ARRAY_BUFFER, vertex_size+texCoord_size, 0, GL_STATIC_DRAW);
    
    GLvoid* vbo_buffer = glMapBufferOES(GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
	// transfer the vertex data to the VBO
	memcpy(vbo_buffer, squareVertices, vertex_size);
    
	// append color data to vertex data. To be optimal, 
	// data should probably be interleaved and not appended
	vbo_buffer += vertex_size;
	memcpy(vbo_buffer, spriteTextureCoordinates, texCoord_size);
    glUnmapBufferOES(GL_ARRAY_BUFFER); 
    
    // create index buffer
    glGenBuffers(1, &cubeIBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, cubeIBO);
    
    // For constrast, instead of glBufferSubData and glMapBuffer, 
    // we can directly supply the data in one-shot
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 4*sizeof(GLubyte), s_squareIndices, GL_STATIC_DRAW);
    
}

-(void) InitSpriteWithTexture: (GLfloat[8]) texCoords
{
    static const GLfloat s_squareVertices[] = { 
        -10.0f, -10.0f, 
        10.0f, -10.0f, 
        -10.0f, 10.0f, 
        10.0f,  10.0f,
    };
    
    for(int i = 0; i < 8; i++)
    {
        spriteTextureCoordinates[i] = texCoords[i];
    }
    
    squareVertices = s_squareVertices;
}

- (void) DrawSprite
{
    glBindTexture(GL_TEXTURE_2D, mSpriteTexture);
    
    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    
    if(mSpriteTexture)
    {
        glTexCoordPointer(2, GL_FLOAT, 0, spriteTextureCoordinates); 
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    }
    else
    {
        glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
        glEnableClientState(GL_COLOR_ARRAY);
    }
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

-(void) DrawSpriteES2WithoutTexture:(int)VertexAttribute :(int)ColorAttribute
{
    // Update attribute values.
    glVertexAttribPointer(VertexAttribute, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(VertexAttribute);
    glVertexAttribPointer(ColorAttribute, 4, GL_UNSIGNED_BYTE, 1, 0, squareColors);
    glEnableVertexAttribArray(ColorAttribute);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

-(void) DrawSpriteES2WithTexture:(int)VertexAttribute :(int)TexCoordAttribute:(int)UniformSampler
{
    // Update attribute values.
    
    // Activate the VBOs to draw
    glBindBuffer(GL_ARRAY_BUFFER, cubeVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, cubeIBO);
    
    glVertexAttribPointer(VertexAttribute, 2, GL_FLOAT, 0, 0, (GLvoid*)((char*)NULL));
    glEnableVertexAttribArray(VertexAttribute);
    glVertexAttribPointer(TexCoordAttribute, 2, GL_FLOAT, 1, 0,(GLvoid*)((char*)NULL+vertex_size));
    glEnableVertexAttribArray(TexCoordAttribute);
    
    glBindTexture(GL_TEXTURE_2D, mSpriteTexture);
    glUniform1i(UniformSampler, mSpriteTexture);
    
    glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_BYTE, (GLvoid*)((char*)NULL));
    
    //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

- (void) InitTexture : (NSString* const) textureName
{
    CGImageRef spriteImage;
    CGContextRef spriteContext;
    GLubyte *spriteData;
	size_t	width, height;
    
    // Creates a Core Graphics image from an image file
	spriteImage = [UIImage imageNamed:textureName].CGImage;
	// Get the width and height of the image
	width = CGImageGetWidth(spriteImage);
	height = CGImageGetHeight(spriteImage);
	// Texture dimensions must be a power of 2. If you write an application that allows users to supply an image,
	// you'll want to add code that checks the dimensions and takes appropriate action if they are not a power of 2.
    
	if(spriteImage) {
		// Allocated memory needed for the bitmap context
		spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
		// Uses the bitmap creation function provided by the Core Graphics framework. 
		spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width * 4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
		// After you create the context, you can draw the sprite image to the context.
		CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), spriteImage);
		// You don't need the context at this point, so you need to release it to avoid memory leaks.
		CGContextRelease(spriteContext);
		
		// Use OpenGL ES to generate a name for the texture.
		glGenTextures(1, &mSpriteTexture);
		// Bind the texture name. 
		glBindTexture(GL_TEXTURE_2D, mSpriteTexture);
		// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
		// Specify a 2D texture image, providing the a pointer to the image data in memory
		glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
		// Release the image data
		free(spriteData);
		
		// Enable use of the texture
		glEnable(GL_TEXTURE_2D);
		// Set a blending function to use
		glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
		// Enable blending
		glEnable(GL_BLEND);
    }
}

@end
