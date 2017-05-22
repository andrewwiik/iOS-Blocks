//
//  IBKMusicButton.h
//  Music
//
//  Created by Matt Clarke on 05/02/2015.
//
//

#import <UIKit/UIKit.h>
#include <dlfcn.h>
#import "chatsTableView.h"
#import <objc/runtime.h>

#define row_rowid 0

#define row_guid 1

#define row_style 2

#define row_state 3

#define row_account_id 4

#define row_properties 5

#define row_chat_identifer 6

#define row_service_name 7

#define row_room_name 8

#define row_account_login 9

#define row_is_archived 10

#define row_last_address_handle 11

#define row_display_name 12

#define row_group_id 13

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)


@interface MobileSMSContentView : UIView

@property (nonatomic, strong) chatsTableView *table;

@end

@interface IBKAPI : NSObject

+(CGFloat)heightForContentViewWithIdentifier:(NSString *)identifier;

@end
