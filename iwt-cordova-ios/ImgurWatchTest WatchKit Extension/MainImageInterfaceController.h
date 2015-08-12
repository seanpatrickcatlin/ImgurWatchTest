//
//  MainImageInterfaceController.h
//  ImgurWatchTest
//
//  Created by Sean Catlin on 8/11/15.
//
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

@interface MainImageInterfaceController : WKInterfaceController

@property (weak, nonatomic) IBOutlet WKInterfaceImage* mainImage;
@property (weak, nonatomic) IBOutlet WKInterfaceButton* nextButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton* startStopButton;

-(IBAction)nextTap:(id)sender;
-(IBAction)startStopTap:(id)sender;

@end
