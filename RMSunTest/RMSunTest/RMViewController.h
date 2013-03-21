//
//  RMViewController.h
//  RMSunTest
//
//  Created by Ted Bradley on 13/03/2013.
//  Copyright (c) 2013 Realmac Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *sunrise;
@property (weak, nonatomic) IBOutlet UITextField *sunset;
@property (weak, nonatomic) IBOutlet UIDatePicker *date;
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *longitude;
@property (weak, nonatomic) IBOutlet UILabel *disclaimer;

- (IBAction)calculate:(id)sender;
- (IBAction)tappedView:(id)sender;

@end
