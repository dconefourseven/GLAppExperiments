//
//  GLAppViewController.m
//  GLApp
//
//  Created by David Clarke on 05/08/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GLAppViewController.h"
#import "EAGLView.h"

// Uniform index.
enum {
    UNIFORM_TRANSLATE,
    UNIFORM_ORIENTATION,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};

@interface GLAppViewController ()
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimer *animationTimer;
- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

static CGPoint myPoint;

@implementation GLAppViewController

@synthesize animating;
@synthesize context;
@synthesize displayLink;
@synthesize animationTimer;

static int ScreenWidth = 0, ScreenHeight = 0;
enum ScreenOrientation {Portrait, LandscapeLeft, LandscapeRight, PortraitUpsideDown};
static enum ScreenOrientation CurrentScreenOrientation = LandscapeRight;

- (void)awakeFromNib
{
    //EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    //USE THIS TO INITIALISE OPENGL ES 2
    //Right now we want to use OpenGL ES 1.1. Hence why this is ignored
    
    //if (!aContext)
    //{ 
       EAGLContext* aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    //}
    
    if (!aContext)
        NSLog(@"Failed to create ES context");
    else if (![EAGLContext setCurrentContext:aContext])
        NSLog(@"Failed to set ES context current");
    
	self.context = aContext;
	[aContext release];
	
    [(EAGLView *)self.view setContext:context];
    [(EAGLView *)self.view setFramebuffer];
    
    if ([context API] == kEAGLRenderingAPIOpenGLES2)
        [self loadShaders];
    
    animating = FALSE;
    animationFrameInterval = 1;
    displayLinkSupported = false;
    self.displayLink = nil;
    animationTimer = nil;
  
    myPoint = CGPointMake(0.0f, 0.0f);
    
    ScreenWidth = self.view.frame.size.width;
    ScreenHeight = self.view.frame.size.height;
    
    accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = .1;
    accelerometer.delegate = self;
    
    mSprite = [[Sprite alloc]init:@"Sprite.png"];
    
    mSpriteFont = [[SpriteFont alloc] init:@"Hello World"];
    
    // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
    // class is used as fallback when it isn't available.
    NSString *reqSysVer = @"3.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
        displayLinkSupported = TRUE;
}

- (void)dealloc
{
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }
    
    [mSprite release];
    [mSprite dealloc];
    [mSpriteFont release];
    [mSpriteFont dealloc];
    
    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    [context release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self startAnimation];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAnimation];
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }

    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	self.context = nil;	
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    /*
	 Frame interval defines how many display frames must pass between each time the display link fires.
	 The display link will only fire 30 times a second when the frame internal is two on a display that refreshes 60 times a second. The default frame interval setting of one will fire 60 times a second when the display refreshes at 60 times a second. A frame interval setting of less than one results in undefined behavior.
	 */
    if (frameInterval >= 1) {
        animationFrameInterval = frameInterval;
        
        if (animating) {
            [self stopAnimation];
            [self startAnimation];
        }
    }
}

- (void)startAnimation
{  
    if (!animating)
	{
		if (displayLinkSupported)
		{
			// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
			// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
			// not be called in system versions earlier than 3.1.
			displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawFrame)];
			[displayLink setFrameInterval:animationFrameInterval];
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
		else
			self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView) userInfo:nil repeats:TRUE];
		
		animating = TRUE;
	}

}

- (void)stopAnimation
{
    if (animating) {
        [self.displayLink invalidate];
        self.displayLink = nil;
        animating = FALSE;
    }
}



- (void)drawFrame
{
    [(EAGLView *)self.view setFramebuffer];
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    #if defined(DEBUG)
    #endif
    
    
    /*//Replace the implementation of this method to do your own custom drawing.
        static const GLfloat squareVertices[] = {
            -25.0f, -25.0f,
            25.0f, -25.0f,
            -25.0f,  25.0f,
            25.0f,  25.0f,
        };
    
    
    static const GLubyte squareColors[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };
    
    static float transY = 0.0f;
    
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
        
    
    if ([context API] == kEAGLRenderingAPIOpenGLES2) {
        
        // Use shader program.
        glUseProgram(program);
        
        // Update uniform value.
        glUniform1f(uniforms[UNIFORM_TRANSLATE], (GLfloat)transY);	
        
        if(CurrentScreenOrientation == LandscapeRight)
        {
            glUniform1i(uniforms[UNIFORM_ORIENTATION], 0);
        }
        if(CurrentScreenOrientation == LandscapeLeft)
        {
            glUniform1i(uniforms[UNIFORM_ORIENTATION], 1);
        }
        
        // Update attribute values.
        glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
        glEnableVertexAttribArray(ATTRIB_VERTEX);
        glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, 1, 0, squareColors);
        glEnableVertexAttribArray(ATTRIB_COLOR);
        
        // Validate program before drawing. This is a good check, but only really necessary in a debug build.
        // DEBUG macro must be defined in your debug configurations if that's not already the case.
#if defined(DEBUG)
        if (![self validateProgram:program]) {
            NSLog(@"Failed to validate program: %d", program);
            return;
        }
#endif
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    }
    else
    {*/
    
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();

        glOrthof(0, ScreenWidth, ScreenHeight, 0, -1.0f, 1.0f);  
    
        glPushMatrix();   // Push a matrix to the stack
    
        if(CurrentScreenOrientation == LandscapeRight)
        {
            //Right screen orientation
            glRotatef(90.0f, 0.0f, 0.0f, 1.0f); // Rotate 90 degrees
            glTranslatef(0.0f, -ScreenWidth, 0.0f);  // Move vertically the screen Width
        }
        
        if(CurrentScreenOrientation == LandscapeLeft)
        {
            //Left screen orientation
            glRotatef(-90.0f, 0.0f, 0.0f, 1.0f);
            glTranslatef(-ScreenHeight, 0.0f, 0.0f); // Move horizontally the screen Height
        }
    
        /// Draw Stuff
        
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
    
        glPushMatrix();
    
        glTranslatef(240.0f, 100.0, 0.0f);
    
        //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        [mSprite DrawSprite];
    
        glPopMatrix();
    
        glPushMatrix();
    
        glTranslatef(myPoint.y, myPoint.x, 0.0f);     
    
        //glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        [mSprite DrawSprite];
    
        glPopMatrix();
    
       static int testInt = 0;
        
        testInt ++;
    
        NSString* testNSString = [[NSString alloc]initWithFormat:@"%d", testInt];
    
        [mSpriteFont DrawFont:testNSString];
        //[mSpriteFont DrawFont];
    
        glPopMatrix();
        
        [testNSString release];
    
    //}
    
    [(EAGLView *)self.view presentFramebuffer];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[event allTouches] anyObject];
    
    if(CurrentScreenOrientation == LandscapeLeft)
    {
        myPoint.x = [myTouch locationInView:self.view].x;
        myPoint.y = -([myTouch locationInView:self.view].y) + ScreenHeight;
    }
    
    if(CurrentScreenOrientation == LandscapeRight)
    {
        myPoint.x = -([myTouch locationInView:self.view].x) + ScreenWidth;
        myPoint.y = [myTouch locationInView:self.view].y;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[event allTouches] anyObject];
    
    if(CurrentScreenOrientation == LandscapeLeft)
    {
        myPoint.x = [myTouch locationInView:self.view].x;
        myPoint.y = -([myTouch locationInView:self.view].y) + ScreenHeight;
    }
    
    if(CurrentScreenOrientation == LandscapeRight)
    {
        myPoint.x = -([myTouch locationInView:self.view].x) + ScreenWidth;
        myPoint.y = [myTouch locationInView:self.view].y;
    }
    
}


-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	// Get the current device angle
	float x = [acceleration x];
	float y = [acceleration y];
	float angle = atan2(y, x); 
    
    if(angle >= -2.25 && angle <= -0.25)
	{
        /// Orientation is regular Portrait
        //CurrentScreenOrientation = Portrait;
	}
	else if(angle >= -1.75 && angle <= 0.75)
	{
        /// Orientation is Landscape with Home Button on the Left
        CurrentScreenOrientation = LandscapeLeft;
	}
	else if(angle >= 0.75 && angle <= 2.25)
	{
        /// Orientation is Portrait flipped upside down
        //CurrentScreenOrientation = PortraitUpsideDown;
	}
	else if(angle >= -2.25 || angle <= 2.25)
	{
        /// Orientation is Landscape with Home Button on the Right
        CurrentScreenOrientation = LandscapeRight;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{/*
    if ((orientation == UIInterfaceOrientationLandscapeRight) ||
        (orientation == UIInterfaceOrientationLandscapeLeft))
        return YES;*/
    
    return NO;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source)
    {
        NSLog(@"Failed to load vertex shader");
        return FALSE;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0)
    {
        glDeleteShader(*shader);
        return FALSE;
    }
    
    return TRUE;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0)
    {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0)
        return FALSE;
    
    return TRUE;
}

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname])
    {
        NSLog(@"Failed to compile vertex shader");
        return FALSE;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname])
    {
        NSLog(@"Failed to compile fragment shader");
        return FALSE;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(program, ATTRIB_COLOR, "color");
    
    // Link program.
    if (![self linkProgram:program])
    {
        NSLog(@"Failed to link program: %d", program);
        
        if (vertShader)
        {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader)
        {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program)
        {
            glDeleteProgram(program);
            program = 0;
        }
        
        return FALSE;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_TRANSLATE] = glGetUniformLocation(program, "translate");
    uniforms[UNIFORM_ORIENTATION] = glGetUniformLocation(program, "orientation");
    
    // Release vertex and fragment shaders.
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
    
    return TRUE;
}

@end
