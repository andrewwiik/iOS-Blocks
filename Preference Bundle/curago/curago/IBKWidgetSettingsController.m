//
//  IBKWidgetSettingsController.m
//  curago
//
//  Created by Matt Clarke on 19/03/2015.
//
//

#import "IBKWidgetSettingsController.h"

NSBundle *strings;

@interface IBKWidgetSettingsController ()

@end

@interface PSListController ()
- (id)loadSpecifiersFromPlistName:(id)arg1 target:(id)arg2 bundle:(id)arg3;
@end

@implementation IBKWidgetSettingsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)specifiers {
    if (_specifiers == nil) {
		NSMutableArray *testingSpecs = [NSMutableArray array];
        [testingSpecs addObjectsFromArray:[self topGeneralSpecifiers]];
        [testingSpecs addObjectsFromArray:[self widgetSpecificSpecifiers]];
        
        _specifiers = testingSpecs;
    }
    
	return _specifiers;
}

-(NSArray*)topGeneralSpecifiers {
    NSMutableArray *array = [NSMutableArray array];
    
    if (!strings)
        strings = [[NSBundle alloc] initWithPath:@"/Library/PreferenceBundles/Convergance-Prefs.bundle"];
    
    PSSpecifier* groupSpecifier1 = [PSSpecifier groupSpecifierWithName:[strings localizedStringForKey:@"Configuration:" value:@"Configuration:" table:@"Root"]];
    [array addObject:groupSpecifier1];
    
    PSSpecifier *spe = [PSSpecifier preferenceSpecifierNamed:[strings localizedStringForKey:@"Set widget" value:@"Set widget" table:@"Root"] target:self set:nil get:@selector(getIsWidgetSetForSpecifier:) detail:/*[curagoController class]*/nil cell:PSLinkListCell edit:nil];
    [spe setProperty:@"IBKWidgetSelectorController" forKey:@"detail"];
    [spe setProperty:[NSNumber numberWithBool:YES] forKey:@"isController"];
    [spe setProperty:[NSNumber numberWithBool:YES] forKey:@"enabled"];
    
    [array addObject:spe];
    
    return array;
}

-(NSArray*)widgetSpecificSpecifiers {
    NSMutableArray *array = [NSMutableArray array];
    
    NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Curago/Widgets/%@/Settings", [self getRedirectedIdentifierIfNeeded:self.bundleIdentifier]];
    
    NSBundle *widgetBundle = [NSBundle bundleWithPath:path];
    
    array = [self loadSpecifiersFromPlistName:@"Root" target:self bundle:widgetBundle];
    array = [[self localizedSpecifiersForSpecifiers:array andBundle:widgetBundle] mutableCopy];
    
    if ([self respondsToSelector:@selector(navigationItem)]) {
        [[self navigationItem] setTitle:self.displayName];
    }
    
    if (array.count == 0) {
        // Well, shit. No widget settings!?
        // If this is a notification widget, we should provide the notification widget settings.
        // Else, we say no settings associated with this widget.
        
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Curago/Widgets/%@/Info.plist", [self getRedirectedIdentifierIfNeeded:self.bundleIdentifier]]];
        if (!dict || [[dict objectForKey:@"wantsNotificationsTable"] boolValue]) {
            return [self notificationWidgetSettings];
        } else {
            // We definitely have no settings then for this widget.
            PSSpecifier *spe = [PSSpecifier preferenceSpecifierNamed:[strings localizedStringForKey:@"No settings available for this widget" value:@"No settings available for this widget" table:@"Root"] target:self set:nil get:nil detail:nil cell:PSStaticTextCell edit:nil];
            [spe setProperty:[NSNumber numberWithBool:NO] forKey:@"enabled"];
            
            [array addObject:spe];
        }
    }
    
    PSSpecifier *first = [array firstObject];
    if (first.cellType != PSGroupCell) {
        PSSpecifier* groupSpecifier2 = [PSSpecifier groupSpecifierWithName:@""];
        [array insertObject:groupSpecifier2 atIndex:0];
    }
    
    return array;
}

-(NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s andBundle:(NSBundle*)bundle {
	int i;
	for (i=0; i<[s count]; i++) {
		if ([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[bundle localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if ([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [bundle localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: newTitles];
		}
	}
	
	return s;
}

-(NSArray*)notificationWidgetSettings {
    NSMutableArray *array = [NSMutableArray array];
    
    return array;
}

-(NSString*)getIsWidgetSetForSpecifier:(PSSpecifier*)spec {
    return @"";
}

-(void)setSpecifier:(PSSpecifier*)specifier {
    [super setSpecifier:specifier];
    
    // Load up stuff from here!
    self.displayName = [specifier name];
    self.bundleIdentifier = [specifier propertyForKey:@"bundleIdentifier"];
}

-(NSString*)getRedirectedIdentifierIfNeeded:(NSString*)identifier {
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"];
    
    NSDictionary *dict = settings[@"redirectedIdentifiers"];
    
    if (dict && [dict objectForKey:identifier])
        return [dict objectForKey:identifier];
    else
        return identifier;
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
    NSString *fileString = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", [specifier propertyForKey:@"defaults"]];
    
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:fileString]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:fileString atomically:YES];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist"]];
	[dict setObject:self.bundleIdentifier forKey:@"changedBundleIdFromSettings"];
	[dict writeToFile:@"/var/mobile/Library/Preferences/com.matchstic.curago.plist" atomically:YES];
    
	CFStringRef toPost = (__bridge CFStringRef)@"com.matchstic.ibk/settingschangeforwidget";
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), toPost, NULL, NULL, YES);
}

@end
