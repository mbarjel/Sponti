//
//  SPFeedbackViewController.m
//  Sponti
//
//  Created by Melad Barjel on 5/10/13.
//  Copyright (c) 2013 Sponti. All rights reserved.
//

#import "SPFeedbackViewController.h"
#import <MessageUI/MessageUI.h>

@interface SPFeedbackViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UILabel* aboutUsLabel;

@end

@implementation SPFeedbackViewController

- (id)init {
    self = [super init];
    if (self) {
        UIBarButtonItem* barButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Send Email" style:UIBarButtonItemStylePlain target:self action:@selector(emailComposer)];
        [self.navigationItem setRightBarButtonItem:barButtonItem];
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"Contact Us";
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
        self.aboutUsLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean a placerat nisl. Ut fermentum id enim sit amet sagittis. Suspendisse bibendum mi sed blandit convallis. Quisque nisi augue, condimentum lacinia dui ut, imperdiet accumsan urna. Donec at odio convallis, tincidunt urna sed, semper mauris. Maecenas commodo id justo vitae volutpat. Suspendisse gravida ullamcorper lacus vitae euismod. Nam egestas pharetra arcu eget aliquet. Quisque eu nibh blandit, lobortis ligula nec, convallis mi. Pellentesque venenatis lacinia sapien id eleifend. Phasellus feugiat aliquet dapibus.";
        
        CGSize labelSize = [self.aboutUsLabel.text sizeWithFont:self.aboutUsLabel.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        
        self.aboutUsLabel.frame = CGRectMake(10, 10, 300, labelSize.height + 10);
        self.scrollView.contentSize = CGSizeMake(320, labelSize.height + 20);
    }
    return self;
}

- (void)emailComposer {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController* mailComposeViewController = [[MFMailComposeViewController alloc] init];
        [mailComposeViewController setToRecipients:@[@"mbarjel@hotmail.com"]];
        [mailComposeViewController setSubject:@"Sponti Feedback"];
        [mailComposeViewController setMailComposeDelegate:self];
        [mailComposeViewController setMessageBody:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean a placerat nisl. Ut fermentum id enim sit amet sagittis. Suspendisse bibendum mi sed blandit convallis. Quisque nisi augue, condimentum lacinia dui ut, imperdiet accumsan urna. Donec at odio convallis, tincidunt urna sed, semper mauris. Maecenas commodo id justo vitae volutpat. Suspendisse gravida ullamcorper lacus vitae euismod. Nam egestas pharetra arcu eget aliquet. Quisque eu nibh blandit, lobortis ligula nec, convallis mi. Pellentesque venenatis lacinia sapien id eleifend. Phasellus feugiat aliquet dapibus." isHTML:NO];
        [mailComposeViewController setMailComposeDelegate:self];
        mailComposeViewController.modalPresentationStyle = UIModalPresentationFormSheet;
        [self presentViewController:mailComposeViewController animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Email is not setup on this device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    NSLog(@"check if it was successful");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
