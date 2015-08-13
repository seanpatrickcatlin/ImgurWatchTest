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
@property (nonatomic) BOOL autoPlay;
@property (nonatomic, retain) NSString* lastImageUrl;
@property (nonatomic, retain) NSTimer* getNextImageTimer;;
@property (nonatomic, retain) NSMutableArray* imageData;
@property (nonatomic, retain) NSURLSessionDataTask* getListOfImagesTask;
@property (nonatomic, retain) NSURLSessionDataTask* getImageTask;

- (void)showNextImage;
- (void)updateImage:(BOOL)forwards;
- (void)stopAutoPlay;
- (void)startAutoPlay;
- (void)getNextPageOfImages;
- (void)killTimer;

@end

@implementation MainImageInterfaceController

@synthesize imageNumber;
@synthesize lastPageRequested;
@synthesize autoPlay;
@synthesize lastImageUrl;
@synthesize getNextImageTimer;
@synthesize imageData;
@synthesize getListOfImagesTask;
@synthesize getImageTask;

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
    self.autoPlay = NO;
    self.lastImageUrl = @"";
    self.getNextImageTimer = nil;
    self.imageData = [[NSMutableArray alloc] init];
    self.getListOfImagesTask = nil;
    self.getImageTask = nil;

    [self.startStopButton setTitle:NSLocalizedString(@"Start", nil)];

    [self.imageButton setTitle:@""];

    UIImage* iconImage = [UIImage imageNamed:@"icon-76@2x"];
    [self.imageButton setBackgroundImage:iconImage];

    [self showNextImage];
}

- (void)didDeactivate {
    self.autoPlay = NO;

    [self killTimer];

    if(self.getListOfImagesTask != nil) {
        [self.getListOfImagesTask cancel];
        self.getListOfImagesTask = nil;
    }

    if(self.getImageTask != nil) {
        [self.getImageTask cancel];
        self.getImageTask = nil;
    }

    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)updateImage:(BOOL)forwards {
    if(self.getImageTask != nil) {
        return;
    }

    [self killTimer];

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
        self.imageNumber = (int)[self.imageData count]-1;
        [self getNextPageOfImages];
        [self stopAutoPlay];
    }

    [self.prevButton setEnabled:(self.imageNumber > 0)];

    NSString* newImageUrl = @"";

    if(self.imageNumber < [imageData count]) {
        NSDictionary* imageObject = [imageData objectAtIndex:self.imageNumber];
        NSString* imageId = [imageObject valueForKey:@"id"];

        int maxWidth = (int)(self.contentFrame.size.width);
        int maxHeight = (int)(self.contentFrame.size.height*0.75);

        maxWidth*=2;
        maxHeight*=2;

        NSString* thumbnailModifier = @"h";

        float heightScale = 1.0;
        float widthScale = 1.0;

        int imageWidth = [[imageObject valueForKey:@"width"] intValue];
        int imageHeight = [[imageObject valueForKey:@"height"] intValue];

        if(imageWidth > imageHeight) {
            heightScale = (imageHeight / imageWidth);
        } else {
            widthScale = (imageWidth / imageHeight);
        }

        if((maxWidth < (160*widthScale)) || (maxHeight < (160*heightScale))) {
            thumbnailModifier = @"t";
        } else if((maxWidth < (320*widthScale)) || (maxHeight < (320*heightScale))) {
            thumbnailModifier = @"m";
        } else if((maxWidth < (640*widthScale)) || (maxHeight < (640*heightScale))) {
            thumbnailModifier = @"l";
        }

        newImageUrl = [NSString stringWithFormat:@"http://i.imgur.com/%@%@.jpg", imageId, thumbnailModifier];
    }

    if([newImageUrl isEqualToString:self.lastImageUrl]) {
        NSLog(@"Image to display is the same as the one we just displayed, returning early");
        return;
    }

    self.lastImageUrl = newImageUrl;

    NSURL *URL = [NSURL URLWithString:self.lastImageUrl];
    NSMutableURLRequest* imageRequest = [NSMutableURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    self.getImageTask = [session dataTaskWithRequest:imageRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.getImageTask = nil;

        if(error != nil) {
            NSLog(@"Error retrieving image: %@", error);
            // TODO, show an alert here? implement retry logic?
            return;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageButton setBackgroundImageData:data];

            if(self.autoPlay == YES) {
                self.getNextImageTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(showNextImage) userInfo:nil repeats:NO];
            }
        });
    }];

    [self.getImageTask resume];
}

- (void)showNextImage {
    [self updateImage:YES];
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
    if(self.autoPlay == YES) {
        [self stopAutoPlay];
        return;
    }

    [self startAutoPlay];
}

-(void) killTimer {
    if(getNextImageTimer == nil) {
        return;
    }

    [getNextImageTimer invalidate];
    getNextImageTimer = nil;
}

-(void) startAutoPlay {
    [startStopButton setTitle:NSLocalizedString(@"Stop", nil)];

    self.autoPlay = YES;

    // call update image once before creating the timer so that there is an immediate UI change for the user
    [self showNextImage];
}

-(void) stopAutoPlay {
    self.autoPlay = NO;

    [self killTimer];

    if(self.getImageTask != nil) {
        [self.getImageTask cancel];
        self.getImageTask = nil;
    }

    [startStopButton setTitle:NSLocalizedString(@"Start", nil)];
}

- (void)getNextPageOfImages {
    if(self.getListOfImagesTask != nil) {
        return;
    }

    [self stopAutoPlay];

    self.lastPageRequested++;

    NSString* imageListUrl = [NSString stringWithFormat:@"https://api.imgur.com/3/gallery/r/earthporn/time/%d", self.lastPageRequested];

    NSURL *URL = [NSURL URLWithString:imageListUrl];
    NSMutableURLRequest* imageListRequest = [NSMutableURLRequest requestWithURL:URL];
    [imageListRequest setValue:@"Client-ID cc8240616b0b518" forHTTPHeaderField:@"Authorization"];

    NSURLSession *session = [NSURLSession sharedSession];
    self.getListOfImagesTask = [session dataTaskWithRequest:imageListRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        self.getListOfImagesTask = nil;

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

        [self showNextImage];

        }];
    
    [self.getListOfImagesTask resume];
}

@end
