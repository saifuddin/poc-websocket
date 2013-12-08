//
//  LBViewController.h
//  kappor
//
//  Created by saifuddin on 7/12/13.
//  Copyright (c) 2013 saifuddin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGDrawingSlate.h"

@interface LBViewController : UIViewController <MGDrawingSlateDelegate>
@property (weak, nonatomic) IBOutlet MGDrawingSlate *drawingPad;
- (IBAction)clear:(id)sender;

@end
