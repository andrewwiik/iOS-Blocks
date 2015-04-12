//
//  IBKMTAlarmViewController.m
//  MobileTimer
//
//  Created by Matt Clarke on 06/04/2015.
//
//

#import "IBKMTAlarmViewController.h"
#import "IBKMTAlarmsCell.h"
#import <objc/runtime.h>

@interface AlarmManager : NSObject
+ (id)sharedManager;
- (id)alarms;
- (void)loadAlarms;
- (void)updateAlarm:(id)arg1 active:(bool)arg2;
- (void)saveAlarms;
@end

@interface IBKMTAlarmViewController ()

@end

@implementation IBKMTAlarmViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        // Initialization code
    }
    
    return self;
}

-(void)loadAlarmsFromManager {
    AlarmManager *manager = [objc_getClass("AlarmManager") sharedManager];
    [manager loadAlarms];
    self.alarms = [manager alarms];
}

#pragma mark UICollectionView delegate

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IBKMTAlarmsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"alarmsCell" forIndexPath:indexPath];
    [cell setupForAlarm:self.alarms[indexPath.row]];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.alarms count];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.collectionView.frame.size.width/2)-10;
    return CGSizeMake(width, width);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    Alarm *alarm = self.alarms[indexPath.row];
    
    BOOL wasActive = alarm.isActive;
    
    [[objc_getClass("AlarmManager") sharedManager] updateAlarm:alarm active:!wasActive];
    [[objc_getClass("AlarmManager") sharedManager] saveAlarms];
    
    CFPreferencesAppSynchronize(CFSTR("com.apple.mobiletimer"));
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

@end
