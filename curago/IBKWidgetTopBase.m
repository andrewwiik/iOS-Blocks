//
//  IBKWidgetTopBase.m
//  curago
//
//  Created by Matt Clarke on 01/03/2015.
//
//

#import "IBKWidgetTopBase.h"
#import "IBKResources.h"
#import "IBKWidgetViewController.h"

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define RTL_CHECK [NSClassFromString(@"IBKResources") isRTL]

@implementation IBKWidgetTopBase

/*
 * This wee bit of code ensures that touches only hit the original icon view on the bottom left, 
 * precisely where we want to user to tap to launch apps.
*/

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
	//return YES;
	// return YES;
    if ([[NSClassFromString(@"SBIconController") sharedInstance] isEditing]) return NO;
    CGRect rect = CGRectMake(0 + (RTL_CHECK ? self.frame.size.width - (isPad ? 50 : 30) : 0), self.frame.size.height-(isPad ? 50 : 30), (isPad ? 50 : 30), (isPad ? 50 : 30));
    CGRect intersect = CGRectMake(point.x, point.y, 1, 1);
    NSLog(@"GETTING TOUCH EVENT");
    return !CGRectIntersectsRect(rect, intersect);
}

// - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
// {   
// 	//if ([self pointInside:point withEvent:event]) {
// 		UIView *iconView = [self superviewOfClass:NSClassFromString(@"SBIconView")];
// 		CGPoint subPoint = [iconView convertPoint:point fromView:self];
// 		UIView *result = [iconView hitTest:subPoint withEvent:event];
// 		if (result != nil) {
//         	return result;
//         }
// 	//}

//     return nil;
// }
// - (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
// 	return TRUE;
// }

// -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
// {
//     [[self nextResponder] touchesBegan:touches withEvent:event];
//     [super touchesBegan:touches withEvent:event];
// }
// -(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
// {
//     [[self nextResponder] touchesMoved:touches withEvent:event];
//     [super touchesMoved:touches withEvent:event];
// }

// - (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//     [[self nextResponder] touchesEnded:touches withEvent:event];
//     [super touchesEnded:touches withEvent:event];
// }

// - (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//     [[self nextResponder] touchesCancelled:touches withEvent:event];
//     [super touchesCancelled:touches withEvent:event];
// }

// - (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//     CGPoint pointInB = [B convertPoint:point fromView:self];

//     if ([B pointInside:pointInB withEvent:event])
//         return B;

//     return [super hitTest:point withEvent:event];
// }

// - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  
//     [super touchesBegan:touches withEvent:event];
//     [self.nextResponder touchesBegan:touches withEvent:event]; 
// }

// - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {  
//     [super touchesMoved:touches withEvent:event];
//     [self.nextResponder touchesMoved:touches withEvent:event]; 
// }

@end
