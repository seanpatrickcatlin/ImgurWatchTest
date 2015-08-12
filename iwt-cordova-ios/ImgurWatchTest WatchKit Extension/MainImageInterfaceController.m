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
@property (nonatomic) int lastPageRequested;
@property (nonatomic) NSString* lastImageUrl;
@property (nonatomic, retain) NSTimer* autoPlayTimer;
@property (nonatomic, retain) NSMutableArray* imageData;
@property (nonatomic, retain) NSURLSessionDataTask* getImageListTask;

- (void)showNextImage;
- (void)updateImage:(BOOL)forwards;
- (void)stopAutoPlay;
- (void)startAutoPlay;
- (void)killAutoPlayTimer;
- (void)getNextPageOfImages;

@end

@implementation MainImageInterfaceController

@synthesize imageData;
@synthesize imageNumber;
@synthesize autoPlayTimer;
@synthesize getImageListTask;
@synthesize lastPageRequested;

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
    self.lastPageRequested = -1;
    self.autoPlayTimer = nil;
    self.imageData = [[NSMutableArray alloc] init];
    self.getImageListTask = nil;
    self.lastImageUrl = @"";

    [self.startStopButton setTitle:NSLocalizedString(@"Start", nil)];

    [self showNextImage];
}

- (void)didDeactivate {
    [self killAutoPlayTimer];

    if(self.getImageListTask != nil) {
        [self.getImageListTask cancel];
        self.getImageListTask = nil;
    }

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

    if(self.imageNumber >= [self.imageData count]) {
        self.imageNumber = (int)[self.imageData count];
        [self getNextPageOfImages];
        [self stopAutoPlay];
    }

    [self.prevButton setEnabled:(self.imageNumber > 0)];
    [self.nextButton setEnabled:(self.imageNumber < [self.imageData count])];

    NSString* newImageUrl = @"";

    if(self.imageNumber < [imageData count]) {
        NSString* imageId = [[imageData objectAtIndex:self.imageNumber] valueForKey:@"id"];

        newImageUrl = [NSString stringWithFormat:@"http://i.imgur.com/%@t.jpg", imageId];

        NSLog(@"We should be showing image #%d [%@]", self.imageNumber, self.lastImageUrl);
    }

    if([newImageUrl isEqualToString:self.lastImageUrl]) {
        NSLog(@"Image to display is the same as the one we just dispalyed, returning early");
        return;
    }

    self.lastImageUrl = newImageUrl;

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
        img = [[UIImage alloc] initWithCGImage: img.CGImage scale: 0.25 orientation:desiredOrientation];
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

- (void)getNextPageOfImages {
    if(self.getImageListTask != nil) {
        return;
    }

    BOOL resumeAutoPlay = (self.autoPlayTimer != nil);

    [self stopAutoPlay];

    self.lastPageRequested++;

    NSString* imageListUrl = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/r/earthporn/time/%d", self.lastPageRequested];

    NSURL *URL = [NSURL URLWithString:imageListUrl];
    NSMutableURLRequest* imageListRequest = [NSMutableURLRequest requestWithURL:URL];
    [imageListRequest setValue:@"Client-ID cc8240616b0b518" forHTTPHeaderField:@"Authorization"];

    NSURLSession *session = [NSURLSession sharedSession];
    self.getImageListTask = [session dataTaskWithRequest:imageListRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.getImageListTask = nil;

        if(error != nil) {
            NSLog(@"Error retrieving list of images: %@", error);
            // TODO, show an alert here? implement retry logic?
            return;
        }

        NSError* jsonError = nil;
        NSArray* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

        if(jsonError != nil) {
            NSLog(@"Error parsing json list of images: %@", error);
            // TODO, show an alert here? implement retry logic?
            return;
        }

        NSArray* jsonArray = [jsonDictionary valueForKey:@"data"];

        for(NSDictionary* jsonItem in jsonArray) {
            if(([[jsonItem valueForKey:@"nsfw"] boolValue] == NO) && ([[jsonItem valueForKey:@"animated"] boolValue] == NO)) {
                [self.imageData addObject:jsonItem];
            }
        }

        if(resumeAutoPlay == YES) {
            [self startAutoPlay];
        } else {
            [self showNextImage];
        }

        }];
    
    [self.getImageListTask resume];
}

@end
