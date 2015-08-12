//
//  MainImageInterfaceController.m
//  ImgurWatchTest
//
//  Created by Sean Catlin on 8/11/15.
//
//

#import "MainImageInterfaceController.h"

@interface MainImageInterfaceController ()

@property (nonatomic) int imageDisplayCount;
@property (nonatomic) BOOL loopThroughImages;
@property (nonatomic, retain) NSTimer* loopTimer;

- (void)updateImage;

@end

@implementation MainImageInterfaceController

@synthesize imageDisplayCount;
@synthesize loopThroughImages;
@synthesize loopTimer;

@synthesize mainImage;
@synthesize nextButton;
@synthesize startStopButton;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    self.imageDisplayCount = 0;

    [self.startStopButton setTitle:@"Start"];

    self.loopThroughImages = NO;

    [self updateImage];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)updateImage {
    UIImage* img = [UIImage imageNamed:@"icon-76@2x"];

    UIImageOrientation desiredOrientation = UIImageOrientationUp;

    if((self.imageDisplayCount%4) == 1) {
        desiredOrientation = UIImageOrientationRight;
    } else if((self.imageDisplayCount%4) == 2) {
        desiredOrientation = UIImageOrientationDown;
    } else if((self.imageDisplayCount%4) == 3) {
        desiredOrientation = UIImageOrientationLeft;
    }

    if(desiredOrientation != UIImageOrientationUp) {
        img = [[UIImage alloc] initWithCGImage: img.CGImage scale: 1.0 orientation:desiredOrientation];
    }

    [mainImage setImage:img];

    self.imageDisplayCount++;
}

-(IBAction)nextTap:(id)sender {
    [self updateImage];
}

-(IBAction)startStopTap:(id)sender {
    self.loopThroughImages = !self.loopThroughImages;

    // always kill the timer to ensure we have a known timer state (stopped)
    if(self.loopTimer != nil) {
        [self.loopTimer invalidate];
    }
    self.loopTimer = nil;

    // create the timer if needed and update the button title
    if(self.loopThroughImages) {
        [startStopButton setTitle:@"Stop"];

        // call update image once before creating the timer so that there is an immediate UI change for the user
        [self updateImage];

        self.loopTimer = [NSTimer scheduledTimerWithTimeInterval:0.75 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    } else {
        [startStopButton setTitle:@"Start"];
    }
}

@end



