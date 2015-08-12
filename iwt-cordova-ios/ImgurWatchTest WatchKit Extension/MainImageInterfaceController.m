//
//  MainImageInterfaceController.m
//  ImgurWatchTest
//
//  Created by Sean Catlin on 8/11/15.
//
//

#import "MainImageInterfaceController.h"

@interface MainImageInterfaceController ()

@property (nonatomic) int imageNumber;
@property (nonatomic) int availableImageCount;
@property (nonatomic, retain) NSTimer* autoPlayTimer;

- (void)showNextImage;
- (void)updateImage:(BOOL)forwards;
- (void)stopAutoPlay;
- (void)startAutoPlay;
- (void)killAutoPlayTimer;

@end

@implementation MainImageInterfaceController

@synthesize imageNumber;
@synthesize autoPlayTimer;
@synthesize availableImageCount;

@synthesize imageButton;
@synthesize prevButton;
@synthesize nextButton;
@synthesize startStopButton;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    self.imageNumber = -1;
    self.availableImageCount = 20; // completely arbitrary number for testing
    self.autoPlayTimer = nil;

    [self.startStopButton setTitle:NSLocalizedString(@"Start", nil)];

    [self showNextImage];
}

- (void)didDeactivate {
    [self killAutoPlayTimer];

    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)updateImage:(BOOL)forwards {
    if(forwards) {
        self.imageNumber++;
    } else {
        self.imageNumber--;
    }

    if(self.imageNumber <= 0) {
        self.imageNumber = 0;
        [self stopAutoPlay];
    }

    if(self.imageNumber >= self.availableImageCount) {
        self.imageNumber = self.availableImageCount;
        [self stopAutoPlay];
    }

    [self.prevButton setEnabled:(self.imageNumber > 0)];
    [self.nextButton setEnabled:(self.imageNumber < self.availableImageCount)];

    UIImage* img = [UIImage imageNamed:@"icon-76@2x"];

    UIImageOrientation desiredOrientation = UIImageOrientationUp;

    if((self.imageNumber%4) == 1) {
        desiredOrientation = UIImageOrientationRight;
    } else if((self.imageNumber%4) == 2) {
        desiredOrientation = UIImageOrientationDown;
    } else if((self.imageNumber%4) == 3) {
        desiredOrientation = UIImageOrientationLeft;
    }

    if(desiredOrientation != UIImageOrientationUp) {
        img = [[UIImage alloc] initWithCGImage: img.CGImage scale: 1.0 orientation:desiredOrientation];
    }

    [self.imageButton setBackgroundImage:img];
}

- (void)showNextImage {
    [self updateImage:YES];
}

-(IBAction)imageTap:(id)sender {
    NSLog(@"THE IMAGE BUTTON WAS TAPPED!!!");
    [self stopAutoPlay];
}

-(IBAction)prevTap:(id)sender {
    [self stopAutoPlay];
    [self updateImage:NO];
}

-(IBAction)nextTap:(id)sender {
    [self stopAutoPlay];
    [self updateImage:YES];
}

-(IBAction)startStopTap:(id)sender {
    if(self.autoPlayTimer == nil) {
        [self startAutoPlay];
        return;
    }

    [self stopAutoPlay];
}

-(void) killAutoPlayTimer {
    if(self.autoPlayTimer == nil) {
        return;
    }

    [self.autoPlayTimer invalidate];
    self.autoPlayTimer = nil;
}

-(void) startAutoPlay {
    // kill the timer just in case there is one already running
    [self killAutoPlayTimer];

    [startStopButton setTitle:NSLocalizedString(@"Stop", nil)];

    // call update image once before creating the timer so that there is an immediate UI change for the user
    [self showNextImage];

    self.autoPlayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showNextImage) userInfo:nil repeats:YES];
}

-(void) stopAutoPlay {
    [self killAutoPlayTimer];

    [startStopButton setTitle:NSLocalizedString(@"Start", nil)];
}

@end
