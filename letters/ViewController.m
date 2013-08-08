//
//  ViewController.m
//  letters
//
//  Created by benke on 15.07.13.
//  Copyright (c) 2013 benke. All rights reserved.
//

#import "ViewController.h"
#import "LevelViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    float sizeText;
    UIDevice *thisDevice = [UIDevice currentDevice];
    sizeText = [self sizeTextDevice:thisDevice];
    UILabel *lettersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/12)];
    lettersLabel.text = @"Letters";
    lettersLabel.textAlignment = UITextAlignmentCenter;
    lettersLabel.backgroundColor = [UIColor clearColor];
    lettersLabel.font = [lettersLabel.font fontWithSize:sizeText];
    [self.view addSubview:lettersLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressStart:(id)sender
{
    LevelViewController *levelViewController = (LevelViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"LevelViewController"];
    levelViewController.numberLevel = 1;
    [self presentViewController:levelViewController animated:YES completion:nil];
}

- (float)sizeTextDevice:(UIDevice *)thisDevice
{
    float sizeText;
    if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        sizeText = gSizeTextIPhone;
    }
    if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        sizeText = gSizeTextIPad;
    }
    return sizeText;
}
@end
