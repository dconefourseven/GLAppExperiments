//
//  GLAppViewController.m
//  GLApp
//
//  Created by David Clarke on 05/08/2011.
//  Copyright 2011 David Clarke. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GLAppViewController.h"
#import "EAGLView.h"

#import "Audio.h"
#import "ScreenManager.h"

#import "GameplayScreen.h"
#import "MenuScreen.h"

@interface GLAppViewController ()
@property (nonatomic, retain) EAGLContext *context;
@property (nonatomic, assign) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimer *animationTimer;

@end

static CGPoint myPoint;

@implementation GLAppViewController

@synthesize animating;
@synthesize context;
@synthesize displayLink;
@synthesize animationTimer;
@synthesize mScreenManager;

static int ScreenWidth = 0, ScreenHeight = 0;

- (void)awakeFromNib
{
    srand(time(NULL));
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    EAGLContext *aContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];    
    
    if (!aContext)
        NSLog(@"Failed to create ES context");
    else if (![EAGLContext setCurrentContext:aContext])
        NSLog(@"Failed to set ES context current");
    
	self.context = aContext;
	[aContext release];
	
    [(EAGLView *)self.view setContext:context];
    [(EAGLView *)self.view setFramebuffer];
    
    animating = FALSE;
    animationFrameInterval = 1;
    displayLinkSupported = false;
    self.displayLink = nil;
    animationTimer = nil;
    
    myPoint = CGPointMake(0.0f, 0.0f);
    
    ScreenWidth = self.view.frame.size.width;
    ScreenHeight = self.view.frame.size.height;
    
    animating = FALSE;
    animationFrameInterval = 1;
    self.displayLink = nil;
    
    mAudio = [[Audio alloc]init];

    
    mScreenManager = [[ScreenManager alloc]init];
    
    [mScreenManager AddScreen:[[GameplayScreen alloc]init]];
    [mScreenManager AddScreen:[[MenuScreen alloc]init]];
}

- (void)dealloc
{
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }
    
    [mAudio dealloc];
    
    [mScreenManager dealloc];
    
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
    
    [mScreenManager Update];
    [mScreenManager Draw];

    [(EAGLView *)self.view presentFramebuffer];
    
}

/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *myTouch = [[event allTouches] anyObject];
    
    myPoint = [myTouch locationInView:self.view];
}*/

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*UITouch *myTouch = [[event allTouches] anyObject];
     
     myPoint = [myTouch locationInView:self.view]; */   
}

-(BOOL)TouchedEnemy:(const CGPoint) TouchCoordinates: (const float) XScale: (const float) YScale: 
(const float)EnemyXPos: (const float)EnemyYPos: (const float)EnemyXScale: (const float)EnemyYScale
{     
    if(TouchCoordinates.x - (XScale/2) > EnemyXPos + (EnemyXScale/2))
        return NO;
    if(TouchCoordinates.x + (XScale/2) < EnemyXPos - (EnemyXScale/2))
        return NO;
    if(TouchCoordinates.y - (YScale/2) > EnemyYPos + (EnemyYScale/2))
        return NO;
    if(TouchCoordinates.y + (YScale/2) < EnemyYPos - (EnemyYScale/2))
        return NO;
    
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ((orientation == UIInterfaceOrientationLandscapeRight) ||
        (orientation == UIInterfaceOrientationLandscapeLeft))
        return YES;
    
    return NO;
}
@end
