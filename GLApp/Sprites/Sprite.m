//
//  Sprite.m
//  GLApp
//
//  Created by David Clarke on 11/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

#define AmountOfVertices 8
#define AmountOfComponentsPerVertex 2

#define AmountOfTextureCoordinates 8
#define AmountOfComponentsPerTextureCoordinate 2

#define AmountOfColours 16
#define AmountOfComponentsPerColor 4

const GLsizeiptr vertex_size = AmountOfVertices*AmountOfComponentsPerVertex*sizeof(GLfloat);
const GLsizeiptr texCoord_size = AmountOfTextureCoordinates*AmountOfComponentsPerTextureCoordinate*sizeof(GLfloat);
const GLsizeiptr color_size = AmountOfColours*AmountOfComponentsPerColor*sizeof(GLushort);

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

static const GLushort s_squareColors[] = {
    255, 0, 0, 0,
    255, 0, 0, 0,
    0, 0, 0, 0,
    0, 0, 0, 0,
};

// Describes a box, but without a top and bottom
static const GLushort s_squareIndices[] = 
{
    0,1,
    2,3,
};

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

-(id) initWithoutTexture:(GLfloat[8]) texCoords
{
    self = [super init];
    if (self) {
        // Initialization code here.
        [self InitSpriteWithTexture:texCoords];
    }
    
    return self;
}

- (void) InitSprite
{
    
    //squareColors = s_squareColors;
    //squareVertices = s_squareVertices;
    
    // allocate a new buffer
    glGenBuffers(1, &cubeVBO);
    // bind the buffer object to use
    glBindBuffer(GL_ARRAY_BUFFER, cubeVBO);
    
    glBufferData(GL_ARRAY_BUFFER, vertex_size+color_size, 0, GL_STATIC_DRAW);
    
    GLvoid* vbo_buffer = glMapBufferOES(GL_ARRAY_BUFFER, GL_WRITE_ONLY_OES);
	// transfer the vertex data to the VBO
	memcpy(vbo_buffer, s_squareVertices, vertex_size);
    
	// append color data to vertex data. To be optimal, 
	// data should probably be interleaved and not appended
	vbo_buffer += vertex_size;
	memcpy(vbo_buffer, s_squareColors, color_size);
    glUnmapBufferOES(GL_ARRAY_BUFFER); 
    
    // create index buffer
    glGenBuffers(1, &cubeIBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, cubeIBO);
    
    // For constrast, instead of glBufferSubData and glMapBuffer, 
    // we can directly supply the data in one-shot
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, 4*sizeof(GLushort), s_squareIndices, GL_STATIC_DRAW);
    
}



- (void) InitSprite: (NSString* const) textureName
{
    [self InitTexture:textureName];
    
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
     memcpy(vbo_buffer, s_spriteTexcoords, texCoord_size);
     glUnmapBufferOES(GL_ARRAY_BUFFER); 
     
     // create index buffer
     glGenBuffers(1, &cubeIBO);
     glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, cubeIBO);
     
     // For constrast, instead of glBufferSubData and glMapBuffer, 
     // we can directly supply the data in one-shot
     glBufferData(GL_ELEMENT_ARRAY_BUFFER, 4*sizeof(GLushort), s_squareIndices, GL_STATIC_DRAW);
    
}

-(void) InitSpriteWithTexture: (GLfloat[8]) texCoords
{
    for(int i = 0; i < 8; i++)
    {
        spriteTextureCoordinates[i] = texCoords[i];
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
     memcpy(vbo_buffer, texCoords, texCoord_size);
     glUnmapBufferOES(GL_ARRAY_BUFFER); 
     
     // create index buffer
     glGenBuffers(1, &cubeIBO);
     glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, cubeIBO);
     
     // For constrast, instead of glBufferSubData and glMapBuffer, 
     // we can directly supply the data in one-shot
     glBufferData(GL_ELEMENT_ARRAY_BUFFER, 4*sizeof(GLushort), s_squareIndices, GL_STATIC_DRAW);
}

-(void) DrawSpriteES2WithoutTexture:(int)VertexAttribute :(int)ColorAttribute
{
    // Activate the VBOs to draw
    glBindBuffer(GL_ARRAY_BUFFER, cubeVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, cubeIBO);
    
    // Update attribute values.
    glVertexAttribPointer(VertexAttribute, 2, GL_FLOAT, 0, 0, (GLvoid*)((char*)NULL));
    glEnableVertexAttribArray(VertexAttribute);
    glVertexAttribPointer(ColorAttribute, 4, GL_UNSIGNED_BYTE, 1, 0, (GLvoid*)((char*)NULL+vertex_size));
    glEnableVertexAttribArray(ColorAttribute);
    
    glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, (GLvoid*)((char*)NULL));
}

-(void) DrawSpriteES2WithTexture:(int)VertexAttribute :(int) TexCoordAttribute:(int) UniformSampler
{
    glBindTexture(GL_TEXTURE_2D, mSpriteTexture);
    
    // Activate the VBOs to draw
    glBindBuffer(GL_ARRAY_BUFFER, cubeVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, cubeIBO);
    
    // Update attribute values.
    glVertexAttribPointer(VertexAttribute, 2, GL_FLOAT, 0, 0, (GLvoid*)((char*)NULL));
    glEnableVertexAttribArray(VertexAttribute);
    glVertexAttribPointer(TexCoordAttribute, 2, GL_FLOAT, 1, 0,(GLvoid*)((char*)NULL+vertex_size));
    glEnableVertexAttribArray(TexCoordAttribute);
    
    glBindTexture(GL_TEXTURE_2D, mSpriteTexture);
    glUniform1i(UniformSampler, mSpriteTexture);
    
    glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, (GLvoid*)((char*)NULL));
}

-(void) DrawSpriteES2WithUniqueTexture:(GLuint) texture: (int)VertexAttribute :(int) TexCoordAttribute:(int) UniformSampler
{
    glBindTexture(GL_TEXTURE_2D, mSpriteTexture);
    
    // Activate the VBOs to draw
    glBindBuffer(GL_ARRAY_BUFFER, cubeVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, cubeIBO);
    
    // Update attribute values.
    glVertexAttribPointer(VertexAttribute, 2, GL_FLOAT, 0, 0, (GLvoid*)((char*)NULL));
    glEnableVertexAttribArray(VertexAttribute);
    glVertexAttribPointer(TexCoordAttribute, 2, GL_FLOAT, 1, 0,(GLvoid*)((char*)NULL+vertex_size));
    glEnableVertexAttribArray(TexCoordAttribute);
    
    glBindTexture(GL_TEXTURE_2D, texture);
    glUniform1i(UniformSampler, texture);
    
    glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, (GLvoid*)((char*)NULL));
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

-(void)DeleteBuffers
{
    glDeleteBuffers(1, &cubeIBO);
    glDeleteBuffers(1, &cubeVBO);
}

-(void)dealloc
{
    [self DeleteBuffers];
    
    glDeleteVertexArraysOES(sizeof(squareVertices), (const GLuint*)squareVertices);
    if(mSpriteTexture != 0)
        glDeleteTextures(sizeof(mSpriteTexture), &mSpriteTexture);
    
    [super dealloc];
}

@end
