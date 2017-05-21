//
//  cydiaIconView.h
//  Cydia
//
//  Created by gabriele filipponi on 18/08/15.
//
//

#import <UIKit/UIKit.h>
#import "cydiaNewBanner.h"

@interface cydiaIconView : UIImageView {
    cydiaNewBanner *banner;
    BOOL show;
}

-(void)setNew:(BOOL)arg;

@end
