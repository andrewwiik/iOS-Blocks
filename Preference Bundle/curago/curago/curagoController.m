//
//  curagoController.m
//  curago
//
//  Created by Matt Clarke on 21/02/2015.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "curagoController.h"
#import "IBKCarouselCell.h"
#import <Preferences/PSSpecifier.h>

static curagoController *shared;
static int currentIndex = 0;

@implementation curagoController

+(instancetype)sharedInstance {
    return shared;
}

-(id)init {
    self = [super init];
    if (self) {
        shared = self;
        self.headerview = [[IBKHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.table.frame.size.width, 345)];
    }
    
    return self;
}

-(id)specifiers {
    if (_specifiers == nil) {
		NSMutableArray *testingSpecs = [self loadSpecifiersFromPlistName:@"Root" target:self];
        testingSpecs = [[self localizedSpecifiersForSpecifiers:testingSpecs] mutableCopy];
        
        [testingSpecs addObjectsFromArray:[self getPrefsForIndex:currentIndex]];
        
        _specifiers = testingSpecs;
    }
    
	return _specifiers;
}

-(NSArray *)localizedSpecifiersForSpecifiers:(NSArray *)s {
	int i;
	for (i=0; i<[s count]; i++) {
		if ([[s objectAtIndex: i] name]) {
			[[s objectAtIndex: i] setName:[[self bundle] localizedStringForKey:[[s objectAtIndex: i] name] value:[[s objectAtIndex: i] name] table:nil]];
		}
		if ([[s objectAtIndex: i] titleDictionary]) {
			NSMutableDictionary *newTitles = [[NSMutableDictionary alloc] init];
			for(NSString *key in [[s objectAtIndex: i] titleDictionary]) {
				[newTitles setObject: [[self bundle] localizedStringForKey:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] value:[[[s objectAtIndex: i] titleDictionary] objectForKey:key] table:nil] forKey: key];
			}
			[[s objectAtIndex: i] setTitleDictionary: newTitles];
		}
	}
	
	return s;
}

-(NSArray*)getPrefsForIndex:(int)index {
    currentIndex = index;
    NSArray *specifiers = [NSMutableArray array];
    
    switch (index) {
        case 0:
            specifiers = [self loadSpecifiersFromPlistName:@"Manage" target:self];
            break;
        case 1:
            specifiers = [self loadSpecifiersFromPlistName:@"Advanced" target:self];
            break;
        case 2:
            specifiers = [self loadSpecifiersFromPlistName:@"Support" target:self];
            break;
    }
    
    specifiers = [self localizedSpecifiersForSpecifiers:specifiers];
    
    return specifiers;
}

-(void)loadInPrefsForIndex:(int)index animated:(BOOL)animated {
    NSArray *specifiers = [self getPrefsForIndex:index];
    
    for (int i = (int)[self.specifiers count] - 1; i > -1; i--) {
        [self removeSpecifier:[_specifiers objectAtIndex:i] animated:animated];
    }
    
    [self insertContiguousSpecifiers:specifiers atIndex:0 animated:animated];
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    [super didMoveToParentViewController:parent];
    
    if (!parent) {
        currentIndex = 0;
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.headerview beginAnimations];
}

-(void)viewWillAppear:(BOOL)view {
    self.headerview.frame = CGRectMake(0, 0, self.table.frame.size.width, 365);
    [self.table setTableHeaderView:self.headerview];
    
    // Set title!
    
    if ([self respondsToSelector:@selector(navigationItem)]) {
        [[self navigationItem] setTitle:@"iOS Blocks"];
    }
    
    [super viewWillAppear:view];
}

@end