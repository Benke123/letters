//
//  LevelViewController.m
//  letters
//
//  Created by benke on 15.07.13.
//  Copyright (c) 2013 benke. All rights reserved.
//

#import "LevelViewController.h"

@interface LevelViewController () {
    UIButton *backButton;
    UILabel *levelLabel;
    UILabel *questionLabel;
    UIImageView *answerImage;
    NSMutableArray *buttonAnswerFrame;
    NSString *trueAnswer;
    NSString *normalTrueAnswer;
    NSMutableArray *buttonPressArray;
    NSMutableString *answerMutableString;
    int count;
    int countSpace;
    AVAudioPlayer *sound;
    NSUserDefaults *userDefaults;
}
@end

@implementation LevelViewController

@synthesize numberLevel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    userDefaults = [NSUserDefaults standardUserDefaults];
    NSURL *file = [[NSBundle mainBundle] URLForResource:@"letters" withExtension:@"plist"];
    NSDictionary *plistContent = [NSDictionary dictionaryWithContentsOfURL:file];
    NSArray *questionArray = [plistContent objectForKey:@"questions"];
    NSArray *answerArray = [plistContent objectForKey:@"answers"];
    trueAnswer = answerArray[self.numberLevel];
    normalTrueAnswer = [self normalString];
    buttonAnswerFrame = [[NSMutableArray alloc] initWithCapacity:trueAnswer.length];
    if (normalTrueAnswer.length < 15) {
        float heightScreen = self.view.frame.size.height;
        float widthScreen = self.view.frame.size.width;
        UIDevice *thisDevice = [UIDevice currentDevice];
        float sizeText = [self sizeTextDevice:thisDevice];
        [self backButtonCreate];
        [self levelLabelCreate];
        questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(widthScreen / 12, widthScreen / 6, 5 * widthScreen / 6, 3 * widthScreen / 5)];
        questionLabel.textColor = [UIColor whiteColor];
        questionLabel.backgroundColor = [UIColor clearColor];
        questionLabel.textAlignment = UITextAlignmentCenter;
        questionLabel.numberOfLines = 10;
        questionLabel.text = questionArray[self.numberLevel];
        questionLabel.font = [questionLabel.font fontWithSize:sizeText];
        [self.view addSubview:questionLabel];
        answerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, heightScreen - 3 * widthScreen / 5, widthScreen, widthScreen / 4)];
        answerImage.image = [UIImage imageNamed:@"bg_solution@2x.png"];
        [self.view addSubview:answerImage];
        buttonPressArray = [[NSMutableArray alloc] initWithCapacity:trueAnswer.length];
        answerMutableString = [[NSMutableString alloc] initWithCapacity:normalTrueAnswer.length];
        count = 0;
        NSMutableString *str = [self generateRandomString:(14 - trueAnswer.length)];
        [str appendString:trueAnswer];
        str = [self changeString:str];
        [self buttonAnswerCreate];
        [self buttonCreate:str];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonAnswerCreate
{
    float ordinat = answerImage.frame.origin.y;
    float heightScreen = answerImage.frame.size.height;
    float widthScreen = answerImage.frame.size.width;
    float sizeButton;
    int firstSpace;
    if (trueAnswer.length < 10) {
        sizeButton = widthScreen / 15;
    } else {
        sizeButton = widthScreen / 18;
    }
    if ((trueAnswer.length < 9) || ([self firstOccurrenceSpace:trueAnswer] > trueAnswer.length) || ([self firstOccurrenceSpace:trueAnswer] <= 0)) {
        for (int i = 0; i < trueAnswer.length; i++) {
            if ([[NSString stringWithFormat:@"%c", [trueAnswer characterAtIndex:i]] compare:@" " options:NSCaseInsensitiveSearch] == TRUE) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *btnImage = [UIImage imageNamed:@"btn_input@2x.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
                button.frame = CGRectMake((widthScreen - (3 * trueAnswer.length - 1) * sizeButton / 2) / 2 + 3 * i * sizeButton / 2, ordinat + (heightScreen - sizeButton) / 2, sizeButton, sizeButton);
                button.tag = i;
                [self.view addSubview:button];
                [buttonAnswerFrame addObject:button];
            }
        }
    } else {
        if (countSpace == 1) {
            firstSpace = [self firstOccurrenceSpace:trueAnswer] - 1;
        } else {
            if ([self firstOccurrenceSpace:trueAnswer] < 4) {
                NSString *str = [trueAnswer substringFromIndex:[self firstOccurrenceSpace:trueAnswer] + 1];
                firstSpace = [self firstOccurrenceSpace:trueAnswer] + [self firstOccurrenceSpace:str];
            } else {
                firstSpace = [self firstOccurrenceSpace:trueAnswer];
            }
        }
        for (int i = 0; i < firstSpace + 1; i++) {
            if ([[NSString stringWithFormat:@"%c", [trueAnswer characterAtIndex:i]] compare:@" " options:NSCaseInsensitiveSearch] == TRUE) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *btnImage = [UIImage imageNamed:@"btn_input@2x.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
                button.frame = CGRectMake((widthScreen - (3 * (firstSpace + 1) - 1) * sizeButton / 2) / 2 + 3 * i * sizeButton / 2, ordinat + (heightScreen - 5 * sizeButton / 2) / 2, sizeButton, sizeButton);
                button.tag = i;
                [self.view addSubview:button];
                [buttonAnswerFrame addObject:button];
            }
        }
        for (int i = 0; i < trueAnswer.length - firstSpace - 2; i++) {
            if ([[NSString stringWithFormat:@"%c", [trueAnswer characterAtIndex:(i + firstSpace + 2)]] compare:@" " options:NSCaseInsensitiveSearch] == TRUE) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                UIImage *btnImage = [UIImage imageNamed:@"btn_input@2x.png"];
                [button setImage:btnImage forState:UIControlStateNormal];
                button.frame = CGRectMake((widthScreen - (3 * (trueAnswer.length - firstSpace - 2) - 1) * sizeButton / 2) / 2 + 3 * i * sizeButton / 2, ordinat + (heightScreen - 5 * sizeButton / 2) / 2 + 3 * sizeButton / 2, sizeButton, sizeButton);
                button.tag = i + firstSpace + 2;
                [self.view addSubview:button];
                [buttonAnswerFrame addObject:button];
            }
        }
    }
}

- (void)buttonCreate:(NSMutableString *)str
{
    float sizeText;
    float heightScreen = self.view.frame.size.height;
    float widthScreen = self.view.frame.size.width;
    float sizeButton = (widthScreen) / 11;
    UIDevice *thisDevice = [UIDevice currentDevice];
    sizeText = [self sizeTextDevice:thisDevice];
    NSString *charStr;
    for (int i = 0; i < 14; i++) {
        UIImage *btnImage = [UIImage imageNamed:@"btn_letter@2x.png"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i < 7) {
            button.frame = CGRectMake(3 * i * sizeButton / 2 + 3 * widthScreen / 160 + sizeButton / 4, heightScreen - 3 * sizeButton, sizeButton, sizeButton);
        } else {
            button.frame = CGRectMake(3 * (i - 7) * sizeButton / 2 + (widthScreen - 7 * sizeButton) / 8, heightScreen - 3 * sizeButton / 2, sizeButton, sizeButton);
        }
        button.tag = i;
        [button.titleLabel setFont:[UIFont systemFontOfSize:sizeText]];
        [button setBackgroundImage:btnImage forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i < [str length]) {
            NSRange range = NSMakeRange(i, 1);
            charStr = [str substringWithRange: range];
            [button setTitle:charStr forState:UIControlStateNormal];
        }
        if (answerMutableString.length != trueAnswer.length) {
            [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.view addSubview:button];
    }
}

- (void)buttonPress:(UIButton *)button
{
//    [self buttonTap];
    if (button.frame.origin.y > answerImage.frame.origin.y + answerImage.frame.size.height) {
        NSString *currentStr = button.titleLabel.text;
        if (count < answerMutableString.length) {
            for (int i = 0; i < answerMutableString.length; i++) {
                NSString *curString = [NSString stringWithFormat:@"%@", [buttonPressArray objectAtIndex:i]];
                if ([curString compare:@""] == FALSE) {
                    [answerMutableString replaceCharactersInRange:NSMakeRange(i, 1) withString:currentStr];
                    [buttonPressArray replaceObjectAtIndex:i withObject:button];
                    count = i;
                    [UIView animateWithDuration:0.2 animations:^{[self buttonAnimation:button];}];
                    i = answerMutableString.length + 1;
                } else {
                    if (i == answerMutableString.length - 1) {
                        [answerMutableString insertString:currentStr atIndex:(i + 1)];
                        [buttonPressArray insertObject:button atIndex:(i + 1)];
                        count = answerMutableString.length - 1;
                        [UIView animateWithDuration:0.2 animations:^{[self buttonAnimation:button];}];
                        i = answerMutableString.length + 10;
                    }
                }
            }
        } else {
            [answerMutableString insertString:currentStr atIndex:count];
            [buttonPressArray insertObject:button atIndex:count];
            [UIView animateWithDuration:0.2 animations:^{[self buttonAnimation:button];}];
        }
        NSString *answerString = answerMutableString;
        if ([answerString compare:normalTrueAnswer] == FALSE) {
            if (self.numberLevel != 3) {
                [self trueAnswerSound];
                [userDefaults setInteger:(self.numberLevel) forKey:@"completed level"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"level completed!" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            } else {
                [self trueAnswerSound];
                [userDefaults setInteger:(self.numberLevel) forKey:@"completed level"];
                NSLog(@"%i", [userDefaults integerForKey:@"completed level"]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You win!" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        } else {
            if ((count < 0) || (count == normalTrueAnswer.length - 1)) {
                [self falseAnswerSound];
                [UIView animateWithDuration:0.2 animations:^{[self backButtonsAnimation];}];
                [answerMutableString deleteCharactersInRange:NSMakeRange(0, answerMutableString.length)];
                [buttonPressArray removeAllObjects];
                count = -1;
            }
        }
        count++;
    } else {
        int buttonIndex = [buttonPressArray indexOfObject:button];
            [UIView animateWithDuration:0.2 animations:^{[self backOneButtonAnimation:button];}];
            [answerMutableString replaceCharactersInRange:NSMakeRange(buttonIndex, 1) withString:@" "];
            [buttonPressArray replaceObjectAtIndex:buttonIndex withObject:@""];
            count = buttonIndex;
    }
}

- (NSMutableString *)generateRandomString:(int)num {
    NSMutableString *string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(26))];
    }
    return string;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.numberLevel != 3) {
    LevelViewController *levelViewController = (LevelViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"LevelViewController"];
        levelViewController.numberLevel = [userDefaults integerForKey:@"completed level"] + 1;
        [self presentViewController:levelViewController animated:YES completion:nil];
    } else {
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"] animated:YES completion:nil];
    }
    [userDefaults synchronize];
}

- (NSMutableString *)changeString:(NSMutableString *)currentString
{
    NSMutableString *str = [NSMutableString stringWithString:@""];
    char cur;
    for (int i = 0; i < 14; i++) {
        int rand = arc4random()%currentString.length;
        cur = [currentString characterAtIndex:rand];
        if ([[NSString stringWithFormat:@"%c", cur] compare:@" " options:NSCaseInsensitiveSearch] == FALSE) {
            [str appendFormat:@"%C", (unichar)('a' + arc4random_uniform(26))];
        } else {
            [str appendFormat:@"%C", (unichar) cur];
        }
        [currentString deleteCharactersInRange:NSMakeRange(rand, 1)];
    }
    return str;
}

- (void)clickBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)buttonAnimation:(UIButton *)button
{
    UIButton *currentButton = [buttonAnswerFrame objectAtIndex:count];
        button.frame = currentButton.frame;
}

- (void)backOneButtonAnimation:(UIButton *)button
{
    float heightScreen = self.view.frame.size.height;
    float widthScreen = self.view.frame.size.width;
    float sizeButton = widthScreen / 11;
    if (button.tag < 7) {
        button.frame = CGRectMake(3 * button.tag * sizeButton / 2 + 3 * widthScreen / 160 + sizeButton / 4, heightScreen - 3 * sizeButton, sizeButton, sizeButton);
    } else {
        button.frame = CGRectMake(3 * (button.tag - 7) * sizeButton / 2 + (widthScreen - 7 * sizeButton) / 8, heightScreen - 3 * sizeButton / 2, sizeButton, sizeButton);
    }
}

- (void)backButtonsAnimation
{
    float heightScreen = self.view.frame.size.height;
    float widthScreen = self.view.frame.size.width;
    float sizeButton = widthScreen / 11;
    for (int i = 0; i < normalTrueAnswer.length; i++) {
        UIButton *prassedButton = [buttonPressArray objectAtIndex:i];
        if (prassedButton.tag < 7) {
            prassedButton.frame = CGRectMake(3 * prassedButton.tag * sizeButton / 2 + 3 * widthScreen / 160 + sizeButton / 4, heightScreen - 3 * sizeButton, sizeButton, sizeButton);
        } else {
            prassedButton.frame = CGRectMake(3 * (prassedButton.tag - 7) * sizeButton / 2 + (widthScreen - 7 * sizeButton) / 8, heightScreen - 3 * sizeButton / 2, sizeButton, sizeButton);
        }
    }    
}

- (void)buttonTap
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"tap" ofType:@"wav"];
    sound = [[AVAudioPlayer alloc] initWithData:[[NSData alloc] initWithContentsOfFile:path] error:nil];
    [sound play];
}

- (void)falseAnswerSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fail" ofType:@"wav"];
    sound = [[AVAudioPlayer alloc] initWithData:[[NSData alloc] initWithContentsOfFile:path] error:nil];
    [sound play];
}

- (void)trueAnswerSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"];
    sound = [[AVAudioPlayer alloc] initWithData:[[NSData alloc] initWithContentsOfFile:path] error:nil];
    [sound play];
}

- (void)backButtonCreate
{
    UIDevice *thisDevice = [UIDevice currentDevice];
    float sizeText = [self sizeTextDevice:thisDevice];
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width / 5, self.view.frame.size.height / 12)];
    [backButton.titleLabel setFont:[UIFont systemFontOfSize:sizeText]];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)levelLabelCreate
{
    UIDevice *thisDevice = [UIDevice currentDevice];
    float sizeText = [self sizeTextDevice:thisDevice];
    NSString *levelNumber = [NSString stringWithFormat:@"Level %i/4 ", self.numberLevel + 1];
    levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height / 12)];
    levelLabel.text = levelNumber;
    levelLabel.textAlignment = UITextAlignmentRight;
    levelLabel.backgroundColor = [UIColor clearColor];
    levelLabel.font = [levelLabel.font fontWithSize:sizeText];
    [self.view addSubview:levelLabel];
}

- (NSMutableString *)normalString
{
    NSMutableString * str = [[NSMutableString alloc] init];
    countSpace = 0;
    for (int i = 0; i < trueAnswer.length; i++) {
        if ([[NSString stringWithFormat:@"%c", [trueAnswer characterAtIndex:i]] compare:@" " options:NSCaseInsensitiveSearch] == TRUE) {
            [str appendFormat:@"%C", [trueAnswer characterAtIndex:i]];
        } else {
            countSpace++;
        }
    }
    return str;
}

- (NSArray *)indexSpaceArray:(NSString *)string
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < string.length; i++) {
        NSString *currentChar = [NSString stringWithFormat:@"%c", [string characterAtIndex:i]];
        if ([currentChar isEqualToString:@" "]) {
            [array addObject:[NSString stringWithFormat:@"%i", i]];
        }
    }
    return array;
}

- (int)firstOccurrenceSpace:(NSString *)string
{
    NSRange rangOfSpace = [string rangeOfString:@" "];
    int index = rangOfSpace.location;
    if ((index < 0) || (index > string.length)) {
        index = 0;
    }
    return index;
}

- (int)countAnswersSpace:(int)index
{
    int resultat = 0;
    for (int i = 0; i < index + 1; i++) {
        UIButton *currentButton = [buttonAnswerFrame objectAtIndex:i];
        NSString *strTitle = currentButton.currentTitle;
        if ([strTitle compare:@"Yes"] == FALSE) {
            resultat++;
        }
    }
    return resultat;
}
@end