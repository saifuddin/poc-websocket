//
//  MGDrawingSlate.h
//  MGDrawingSlate
//
//  Created by Mihir Garimella on 6/28/12.
//  Copyright (c) 2012 Mihir Garimella.
//  Licensed for use under the MIT License. See the license file included with this source code or visit http://opensource.org/licenses/MIT for more information.
//

#import <UIKit/UIKit.h>

@protocol MGDrawingSlateDelegate <NSObject>
@optional
- (void)moveToPoint:(CGPoint)point;
- (void)addLineToPoint:(CGPoint)point;
@end

@interface MGDrawingSlate : UIView {
    @public UIBezierPath *drawingPath, *drawingPath2;
    @public UIColor *drawingColor, *drawingColor2;
}

@property (weak, nonatomic) id <MGDrawingSlateDelegate> delegate;

- (void)moveToPoint:(CGPoint)point;
- (void)addLineToPoint:(CGPoint)point;
- (void)changeLineWeightTo:(NSInteger)weight;
- (void)changeColorTo:(UIColor *)color;

@end
