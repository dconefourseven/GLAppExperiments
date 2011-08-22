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
    UNIFORM_SCALE,
    UNIFORM_SAMPLER,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum {
    ATTRIB_VERTEX,
    ATTRIB_TEXTURE,
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

- (void)awakeFromNib
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];    
    if (!aContext)
    {
        aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
    }
    
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
    
    mSprite = [[Sprite alloc]init:@"Sprite.png"];
    
    mSpriteFont = [[SpriteFont alloc] init:@"Hello. World"];
    
    animating = FALSE;
    animationFrameInterval = 1;
    self.displayLink = nil;
    
    mEnemies = [[NSMutableArray alloc]initWithObjects:[[Sprite alloc]init:@"Sprite.png"], [[Sprite alloc]init:@"Sprite.png"], [[Sprite alloc]init:@"Sprite.png"], [[Sprite alloc]init:@"Sprite.png"], nil];
    
    mEnemyPositions = malloc(sizeof(EnemyPositions));
    for(int i = 0; i < 4; i++)
    {
        mEnemyPositions->points[i].x = rand() % 480;
        mEnemyPositions->points[i].y = rand() % 320;
    }
}

- (void)dealloc
{
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }
    
    [mSprite release];
    [mSpriteFont release];
    
    [mEnemies release];
    
    // Tear down context.
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    [context release];
    free(mEnemyPositions);
    
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
    if (!animating) {
        CADisplayLink *aDisplayLink = [[UIScreen mainScreen] displayLinkWithTarget:self selector:@selector(drawFrame)];
        [aDisplayLink setFrameInterval:animationFrameInterval];
        [aDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        self.displayLink = aDisplayLink;
        
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
    
    static int testInt = 0;
    
    testInt ++;
    
    NSString* testNSString = [[NSString alloc]initWithFormat:@"%d", testInt];
        
    if ([context API] == kEAGLRenderingAPIOpenGLES2) {
        
        // Use shader program.
        glUseProgram(program);
        
        glUniform2f(uniforms[UNIFORM_TRANSLATE], 240.0f, 100.0f);	
        glUniform2f(uniforms[UNIFORM_SCALE], 1.0f, 1.0f);
        [mSprite DrawSpriteES2WithTexture:ATTRIB_VERTEX :ATTRIB_TEXTURE: UNIFORM_SAMPLER];
        
        // Update uniform value.
        glUniform2f(uniforms[UNIFORM_SCALE], 2.0f, 2.0f);
        glUniform2f(uniforms[UNIFORM_TRANSLATE], myPoint.x, myPoint.y);	        
        [mSprite DrawSpriteES2WithTexture:ATTRIB_VERTEX :ATTRIB_TEXTURE: UNIFORM_SAMPLER];
        
        for (int i = 0; i < mEnemies.count; i++)
        {
            glUniform2f(uniforms[UNIFORM_TRANSLATE], mEnemyPositions->points[i].x, mEnemyPositions->points[i].y);
            [[mEnemies objectAtIndex:i] DrawSpriteES2WithTexture:ATTRIB_VERTEX :ATTRIB_TEXTURE :UNIFORM_SAMPLER];
        }
        
        glUniform2f(uniforms[UNIFORM_SCALE], 1.0f, 1.0f);
        //[mSpriteFont DrawFontES2: uniforms[UNIFORM_TRANSLATE]: ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
        [mSpriteFont DrawFontES2: testNSString: uniforms[UNIFORM_TRANSLATE]: ATTRIB_VERTEX: ATTRIB_TEXTURE: UNIFORM_SAMPLER];
        
        // Validate program before drawing. This is a good check, but only really necessary in a debug build.
        // DEBUG macro must be defined in your debug configurations if that's not already the case.
#if defined(DEBUG)
        if (![self validateProgram:program]) {
            NSLog(@"Failed to validate program: %d", program);
            return;
        }
#endif

    }
    else
    {
    
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();

        glOrthof(0, ScreenHeight, ScreenWidth, 0, -1.0f, 1.0f);  
    
        glPushMatrix();   // Push a matrix to the stack
    
        /// Draw Stuff
        
        glMatrixMode(GL_MODELVIEW);
        glLoadIdentity();
    
        glPushMatrix();
    
        glTranslatef(240.0f, 100.0, 0.0f);
    
        [mSprite DrawSpriteWithTexture];
    
        glPopMatrix();
    
        glPushMatrix();
    
        glTranslatef(myPoint.x, myPoint.y, 0.0f);     
    
        [mSprite DrawSpriteWithTexture];
    
        glPopMatrix();
    
        [mSpriteFont DrawFont:testNSString];
    
        glPopMatrix();
        
        
    
    }
    
    [testNSString release];
    [(EAGLView *)self.view presentFramebuffer];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[event allTouches] anyObject];
    
    myPoint = [myTouch locationInView:self.view];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[event allTouches] anyObject];
    
    myPoint = [myTouch locationInView:self.view];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ((orientation == UIInterfaceOrientationLandscapeRight) ||
        (orientation == UIInterfaceOrientationLandscapeLeft))
        return YES;
    
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
    glBindAttribLocation(program, ATTRIB_TEXTURE, "a_texCoord");
    
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
    uniforms[UNIFORM_SAMPLER] = glGetUniformLocation(program, "s_Texture");
    uniforms[UNIFORM_SCALE] = glGetUniformLocation(program, "scale");
    
    // Release vertex and fragment shaders.
    if (vertShader)
        glDeleteShader(vertShader);
    if (fragShader)
        glDeleteShader(fragShader);
    
    return TRUE;
}

@end
