//
//  MainImageInterfaceController.m
//  ImgurWatchTest
//
//  Created by Sean Catlin on 8/11/15.
//
//

#import "MainImageInterfaceController.h"

@interface MainImageInterfaceController ()

@end

@implementation MainImageInterfaceController

@synthesize mainImage;

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];

    UIImage* img = [UIImage imageNamed:@"icon-60"];

    [mainImage setImage:img];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



