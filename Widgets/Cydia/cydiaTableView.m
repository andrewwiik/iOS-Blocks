//
//  cydiaTableView.m
//  Cydia
//
//  Created by gabriele filipponi on 15/08/15.
//
//

#import "cydiaTableView.h"

@implementation cydiaTableView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        news = [[cydiaNews alloc] init];
        [news performSelectorInBackground:@selector(fetchUpdateWithTable:) withObject:self];
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
        self.separatorColor = [UIColor colorWithWhite:1.0 alpha:0.60];
        CAGradientLayer *maskLayer = maskLayer = [CAGradientLayer layer];
        maskLayer.shouldRasterize = YES;
        maskLayer.rasterizationScale = [UIScreen mainScreen].scale;
        id outerColor = (id)[UIColor clearColor].CGColor;
        id innerColor = (id)[UIColor blackColor].CGColor;
        maskLayer.colors = [NSArray arrayWithObjects:(id)outerColor, (id)innerColor, (id)innerColor, (id)outerColor, nil];
        maskLayer.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.95], [NSNumber numberWithFloat:1.0], nil];
        maskLayer.bounds = self.layer.bounds;
        maskLayer.anchorPoint = CGPointZero;
        maskLayer.zPosition = 1000;
        self.layer.mask = maskLayer;
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction commit];
        loading = [[M13ProgressViewRing alloc] initWithFrame:CGRectMake((frame.size.width - 35.0) / 2.0, (frame.size.height - 35.0) / 2.0, 35.0, 35.0)];
        loading.showPercentage = NO;
        loading.indeterminate = YES;
        loading.primaryColor = [UIColor whiteColor];
        loading.secondaryColor = [UIColor colorWithWhite:1.0 alpha:0.6];
        loading.alpha = 1.0;
        refresh = [[UIRefreshControl alloc] init];
        [refresh addTarget:self action:@selector(refreshRequested) forControlEvents:UIControlEventValueChanged];
        [refresh setTintColor:[UIColor whiteColor]];
        refresh.transform = CGAffineTransformMakeScale(0.7, 0.7);
        [self addSubview:refresh];
        [self addSubview:loading];
    }
    return self;
}

-(M13ProgressViewRing *)getLoading {
    return loading;
}

-(void)setDictionary:(NSDictionary *)arg {
    dict = [[NSDictionary alloc] initWithDictionary:arg];
    [self performSelectorInBackground:@selector(reloadData) withObject:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float y = scrollView.contentOffset.y;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    scrollView.layer.mask.position = CGPointMake(0, y);
    [CATransaction commit];
}

- (void)refreshRequested {
    [refresh endRefreshing];
    [news performSelectorInBackground:@selector(fetchUpdateWithTable:) withObject:self];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[dict allKeys] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cydiaCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[cydiaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell" inTable:self height:[self tableView:tableView heightForRowAtIndexPath:indexPath]];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        cell.preservesSuperviewLayoutMargins = NO;
    }
    NSString *title = [dict.allValues[indexPath.row] objectForKey:@"title"];
    [cell setTitle:title];
    [cell setDescription:[dict.allValues[indexPath.row] objectForKey:@"description"]];
    [cell setImagePackage:[UIImage imageWithContentsOfFile:[dict.allValues[indexPath.row] objectForKey:@"image"]]];
    [cell setNewPackage:[[dict.allValues[indexPath.row] objectForKey:@"new"] boolValue]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *url = [NSString stringWithFormat:@"cydia://package/%@", [dict.allValues[indexPath.row] objectForKey:@"package"]];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35.0;
}

@end
