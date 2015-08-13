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

@property (weak, nonatomic) IBOutlet WKInterfaceButton* imageButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton* prevButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton* nextButton;
@property (weak, nonatomic) IBOutlet WKInterfaceButton* startStopButton;

-(IBAction)prevTap:(id)sender;
-(IBAction)nextTap:(id)sender;
-(IBAction)startStopTap:(id)sender;

@end
