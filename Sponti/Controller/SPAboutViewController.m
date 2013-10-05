//
//  SPAboutViewController.m
//  Sponti
//
//  Created by Melad Barjel on 5/10/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPAboutViewController.h"

@interface SPAboutViewController ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UILabel* aboutUsLabel;

@end

@implementation SPAboutViewController

- (id)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"About Us";
        self.scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:self.scrollView];
        [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        self.aboutUsLabel = [[UILabel alloc] init];
        self.aboutUsLabel.numberOfLines = CGFLOAT_MAX;
        self.aboutUsLabel.font = [UIFont systemFontOfSize:14.f];
        self.aboutUsLabel.textAlignment = NSTextAlignmentLeft;
        self.aboutUsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.scrollView addSubview:self.aboutUsLabel];
        self.aboutUsLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean a placerat nisl. Ut fermentum id enim sit amet sagittis. Suspendisse bibendum mi sed blandit convallis. Quisque nisi augue, condimentum lacinia dui ut, imperdiet accumsan urna. Donec at odio convallis, tincidunt urna sed, semper mauris. Maecenas commodo id justo vitae volutpat. Suspendisse gravida ullamcorper lacus vitae euismod. Nam egestas pharetra arcu eget aliquet. Quisque eu nibh blandit, lobortis ligula nec, convallis mi. Pellentesque venenatis lacinia sapien id eleifend. Phasellus feugiat aliquet dapibus.\n\nPhasellus ante sem, pellentesque eget felis ac, elementum congue diam. Donec in eleifend nulla. Maecenas ut tortor leo. Curabitur sed rutrum lectus, non gravida nisl. Vestibulum cursus ante eu ante dapibus auctor. Etiam ut ante interdum, molestie urna quis, egestas neque. Sed id lacus sem. Sed tempor, diam ac sagittis ullamcorper, risus nisl blandit eros, ac lobortis tortor arcu id lorem. Nulla facilisi. Integer tristique augue sit amet elit tempor, et rutrum lacus bibendum. Suspendisse quis tincidunt massa. Duis et velit urna.\n\nPraesent scelerisque magna mollis risus dignissim egestas. Vestibulum mi leo, tempus sit amet erat eu, dictum tristique turpis. Cras ultrices arcu a turpis volutpat auctor. Suspendisse potenti. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed ac dui sit amet dui adipiscing iaculis ac sit amet eros. Vestibulum molestie tellus eu pulvinar mattis. In dictum arcu nulla, id elementum turpis ultrices a. Aenean rutrum consectetur lacus, nec rutrum dui elementum id.\n\nPhasellus non congue est. Nunc interdum purus at ullamcorper vestibulum. Integer eget porta ligula. Aliquam fermentum sit amet quam in euismod. Morbi justo libero, mattis vitae molestie quis, sodales ut elit. Aliquam vitae tincidunt sapien. Phasellus nec enim vitae ligula tempor euismod. Suspendisse posuere mattis tristique. Etiam purus neque, pulvinar nec nibh non, commodo vehicula odio. Fusce feugiat mattis ligula, vel pellentesque dolor rhoncus eu. Nunc in congue elit. Vivamus convallis risus ac tempor venenatis. Mauris ornare sem tincidunt venenatis luctus. Integer accumsan arcu vel eleifend aliquam. Maecenas aliquet condimentum lobortis.\n\nMaecenas aliquam, mauris ut dignissim dictum, neque odio pulvinar sapien, ut fringilla diam justo euismod felis. Fusce rhoncus condimentum molestie. Etiam vel convallis libero. Nullam gravida mauris mauris, ac ornare turpis aliquet a. Aliquam turpis lacus, tempus et nisl vitae, cursus venenatis nulla. Aliquam iaculis rutrum lacus sed vehicula. Praesent nisl risus, tempus congue nibh vitae, vehicula rutrum sem. Nam aliquam enim quis suscipit tempor. Morbi semper rhoncus diam eget imperdiet.";
        
        CGSize labelSize = [self.aboutUsLabel.text sizeWithFont:self.aboutUsLabel.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        self.aboutUsLabel.frame = CGRectMake(10, 10, 300, labelSize.height + 10);
        self.scrollView.contentSize = CGSizeMake(320, labelSize.height + 20);
    }
    return self;
}

@end
