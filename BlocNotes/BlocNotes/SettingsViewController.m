//
//  SettingsViewController.m
//  BlocNotes
//
//  Created by Joanna Lingenfelter on 8/2/16.
//  Copyright © 2016 JoLingenfelter. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@property (nonatomic, strong) UISwitch *iCloudSwitch;
@property (nonatomic, strong) UILabel *iCloudLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.iCloudLabel = [[UILabel alloc] init];
    self.iCloudLabel.text = @"iCloud";
    self.iCloudLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview: self.iCloudLabel];
    
    self.iCloudSwitch = [[UISwitch alloc] init];
    self.iCloudSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    [self.iCloudSwitch addTarget:self action:@selector(iCloudSwitchState) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.iCloudSwitch];

    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.iCloudSwitch attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.iCloudLabel attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.iCloudSwitch attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.iCloudLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.iCloudSwitch attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWasPressed)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"SwitchState"]) {
        self.iCloudSwitch.on = [defaults boolForKey:@"SwitchState"];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) iCloudSwitchState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([self.iCloudSwitch isOn]) {
        [defaults setBool:YES forKey:@"SwitchState"];
    } else {
        [defaults setBool:NO forKey:@"SwitchState"];
    }
    
}

- (void) doneWasPressed {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
