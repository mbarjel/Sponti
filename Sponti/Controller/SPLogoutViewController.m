//
//  SPLogoutViewController.m
//  Sponti
//
//  Created by Melad Barjel on 5/10/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPLogoutViewController.h"

@interface SPLogoutViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* options;

@end

@implementation SPLogoutViewController

- (id)init {
    self = [super init];
    if (self) {
        
        self.options = @[@"15 minutes",@"30 minutes",@"1 hour",@"3 hours",@"12 hours",@"1 day",@"1 week", @"Never"];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TableViewCellReuseIdentifier"];
        [self.view addSubview:self.tableView];
        
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellReuseIdentifier"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [self.options objectAtIndex:indexPath.item];
    
    if (indexPath.item == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    for (UITableViewCell* cell in [tableView visibleCells]) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
}

@end
