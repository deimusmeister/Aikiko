//
//  GameScene.m
//  Aikiko
//
//  Created by Levon Poghosyan on 11/12/16.
//  Copyright © 2016 Levon Poghosyan. All rights reserved.
//

#import "GameScene.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation GameScene
{
    SKLabelNode*    mTimerLabel;
    NSTimer*        mTimer;
    BOOL            mRunning;
    
    // Background
    SKSpriteNode*   mStage;
    
    // Aikiko
    SKSpriteNode*   mAikiko;
    NSArray*        mAikikoDancingFrames;
    
    // Gyad
    SKSpriteNode*   mGyad;
    NSArray*        mGyadDancingFrames;
    
    // Girl
    SKSpriteNode*   mGirl;
    NSArray*        mGirlDancingFrames;
    
    // Dialogues
    UIView*         mLooserDialogue;
    UIView*         mWinnerDialogue;
    UIView*         mStartupDialogue;
    
    UIButton*       pbutton;
    
    // UI
    UILabel*        startlabel;
    SKLabelNode*    powerLabel;
    
    NSTimer*        mStartTimer;
    NSInteger       mStartupCounter;
    NSDate*         mStartDate;
    NSTimer*        mGyadTimer;
    
    NSInteger       mLevel;
    UIImage*        mScreeshot;
}

- (void)didMoveToView:(SKView *)view {
    // Initialize dialuges
    [self startCounter];
    [self youLooser];
    [self youWinner];
    mLooserDialogue.hidden = YES;
    mWinnerDialogue.hidden = YES;
    
    // Background color
    self.backgroundColor = [UIColor whiteColor];
    
    // Add spotwatch
    mTimerLabel = [SKLabelNode labelNodeWithFontNamed:@"Verdana"];
    mTimerLabel.text = @"00.00.00.000";
    mTimerLabel.fontColor = [UIColor blackColor];
    mTimerLabel.fontSize = 35;
    mTimerLabel.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - 146);
    [self addChild:mTimerLabel];
    mRunning = FALSE;
    
    // Add power label
    powerLabel = [SKLabelNode labelNodeWithFontNamed:@"Verdana-Bold"];
    powerLabel.text = @"DANCE !";
    powerLabel.fontColor = [UIColor blackColor];
    powerLabel.fontSize = 65;
    powerLabel.position = CGPointMake(CGRectGetMidX(self.frame), 250);
    [self addChild:powerLabel];
    
    // Stage
    mStage = [SKSpriteNode spriteNodeWithImageNamed:@"Stage"];
    mStage.position = CGPointMake(CGRectGetMidX(self.frame),
                                  CGRectGetMidY(self.frame));
    CGFloat scaleFactor = self.frame.size.width / mStage.size.width;
    mStage.xScale = scaleFactor;
    mStage.yScale = scaleFactor;
    mStage.zPosition = -1;
    [self addChild:mStage];
    
    // Aikiko
    [self initAikiko];
    
    // Gyad
    [self initGyad];
    
    // Girl
    [self initGirl];
}

-(void)initAikiko
{
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *AikikoAnimatedAtlas = [SKTextureAtlas atlasNamed:@"aikiko"];
    NSUInteger numImages = AikikoAnimatedAtlas.textureNames.count;
    for (NSUInteger i= 1; i <= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"frame-%d", (int)i];
        SKTexture *temp = [AikikoAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    mAikikoDancingFrames = walkFrames;
    
    SKTexture *temp = mAikikoDancingFrames[0];
    mAikiko = [SKSpriteNode spriteNodeWithTexture:temp];
    mAikiko.xScale = 1.4f;
    mAikiko.yScale = 1.4f;
    mAikiko.position = CGPointMake(120, 275);
    [self addChild:mAikiko];
}

-(void)dancingAikiko
{
    //This is our general runAction method to make our bear walk.
    [mAikiko runAction:[SKAction repeatActionForever:
                      [SKAction animateWithTextures:mAikikoDancingFrames
                                       timePerFrame:0.05f
                                             resize:NO
                                            restore:YES]] withKey:@"dancingAikiko"];
    return;
}

-(void)initGyad
{
    // Gyad
    NSMutableArray *pwalkFrames = [NSMutableArray array];
    SKTextureAtlas *palyerAnimatedAtlas = [SKTextureAtlas atlasNamed:@"gyad"];
    NSUInteger pnumImages = palyerAnimatedAtlas.textureNames.count;
    for (NSUInteger i= 1; i <= pnumImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"frame-%d", (int)i];
        SKTexture *temp = [palyerAnimatedAtlas textureNamed:textureName];
        [pwalkFrames addObject:temp];
    }
    mGyadDancingFrames = pwalkFrames;
    
    SKTexture *ptemp = mGyadDancingFrames[0];
    mGyad = [SKSpriteNode spriteNodeWithTexture:ptemp];
    mGyad.xScale = 1.25f;
    mGyad.yScale = 1.25f;
    mGyad.position = CGPointMake(self.frame.size.width  - 120, 275);
    [self addChild:mGyad];
}

-(void)dancingPlayer
{
    //This is our general runAction method to make our bear walk.
    [mGyad runAction:[SKAction repeatActionForever:
                        [SKAction animateWithTextures:mGyadDancingFrames
                                         timePerFrame:0.05f
                                               resize:NO
                                              restore:YES]] withKey:@"dancingPlayer"];
    return;
}

-(void)initGirl
{
    NSMutableArray *walkFrames = [NSMutableArray array];
    SKTextureAtlas *NahiAnimatedAtlas = [SKTextureAtlas atlasNamed:@"nahi"];
    NSUInteger numImages = NahiAnimatedAtlas.textureNames.count;
    for (NSUInteger i= 1; i <= numImages; i++) {
        NSString *textureName = [NSString stringWithFormat:@"frame-%d", (int)i];
        SKTexture *temp = [NahiAnimatedAtlas textureNamed:textureName];
        [walkFrames addObject:temp];
    }
    mGirlDancingFrames = walkFrames;
    
    SKTexture *temp = mGirlDancingFrames[0];
    mGirl = [SKSpriteNode spriteNodeWithTexture:temp];
    mGirl.xScale = 1.25f;
    mGirl.yScale = 1.25f;
    mGirl.position = CGPointMake(CGRectGetMidX(self.frame), 450);
    [self addChild:mGirl];
}

-(void)dancingGirl
{
    //This is our general runAction method to make our bear walk.
    [mGirl runAction:[SKAction repeatActionForever:
                        [SKAction animateWithTextures:mGirlDancingFrames
                                         timePerFrame:0.05f
                                               resize:NO
                                              restore:YES]] withKey:@"dancingGirl"];
    return;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (mRunning)
    {
        [mGirl removeActionForKey:@"OPushing"];
        //[mOrom removeAllActions];
//        if ([mGirl removeActionForKey:@"OPushing"] == nil)
//        {
            CGPoint newPostion = CGPointMake(mGirl.position.x - 30, mGirl.position.y);
            SKAction *action = [SKAction moveTo:newPostion duration:0.25];
            [mGirl runAction:action withKey:@"OPushing"];
//        }
        
        powerLabel.fontColor = [UIColor redColor];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    powerLabel.fontColor = [UIColor blackColor];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)play:(NSInteger)level {
    // Moved to starting position
    [mGirl     runAction:[SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame), 450)  duration:0.0]];

    mLevel = level;
    mTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                              target:self
                                            selector:@selector(timerCalled)
                                            userInfo:nil
                                             repeats:YES];
    mRunning = YES;
    mStartDate = [NSDate date];

    mGyadTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(gyadPushed)
                                                userInfo:nil
                                                 repeats:NO];
    [self dancingAikiko];
    [self dancingPlayer];
    [self dancingGirl];
}

-(void)gyadPushed
{
    NSTimeInterval timeInterval = 1.f / mLevel;
    
    mGyadTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(gyadPushed) userInfo:nil repeats:NO];
    
    //[mOrom removeAllActions];
    [mGirl removeActionForKey:@"OPushing"];
    if ([mGirl actionForKey:@"OPushing"] == nil)
    {
        CGPoint newPostion = CGPointMake(mGirl.position.x + 30, mGirl.position.y);
        SKAction *action = [SKAction moveTo:newPostion duration:timeInterval];
        [mGirl runAction:action withKey:@"OPushing"];
    }
}

-(void)timerCalled
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:mStartDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    mTimerLabel.text = [NSString stringWithFormat:@"Lvl %ld - %@", mLevel, timeString ];
    
    // Check if someone has won
    CGFloat gPosition = mGirl.position.x;
    BOOL playerWon = FALSE;
    if (gPosition > 1024 - 250)
    {
        playerWon = FALSE;
        mRunning = FALSE;
    }
    else if (gPosition < 250)
    {
        playerWon = TRUE;
        mRunning = FALSE;
    }
    
    if (mRunning == FALSE)
    {
        [mTimer invalidate];
        [mGyadTimer invalidate];
        [mAikiko removeAllActions];
        [mGyad removeAllActions];
        [mGirl removeAllActions];
        
        // If the user has won proceed to next lvl
        if (playerWon == TRUE)
        {
            // Make a screenshot
            [self takeScreenshot];
            
            // Show the winner's dialuge
            mWinnerDialogue.hidden = NO;
            
            // YOOHOO sound
            [self playYOOHOO];
        }
        else
        {
            // Show looser's dialogue
            mLooserDialogue.hidden = NO;
            
            // HAHA sound
            [self playHAHA];
            
            if (mLevel > 1)
                pbutton.hidden = NO;
            else
                pbutton.hidden = YES;
        }
    }
}

-(void)playHAHA
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"haha" ofType:@"m4a"];
                       SystemSoundID soundID;
                       AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
                       AudioServicesPlaySystemSound (soundID);
                   });
}

-(void)playYOOHOO
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"yoohoo" ofType:@"m4a"];
                       SystemSoundID soundID;
                       AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
                       AudioServicesPlaySystemSound (soundID);
                   });
}

-(void)startCounter
{
    mStartupDialogue = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 150,25,300,300)];
    mStartupDialogue.layer.borderColor = [UIColor blackColor].CGColor;
    mStartupDialogue.layer.cornerRadius = 10.0f;
    mStartupDialogue.layer.borderWidth = 3.0f;
    mStartupDialogue.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mStartupDialogue];
    
    startlabel = [[UILabel alloc] init];
    [startlabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    startlabel.text = @"The Dance\nStarts in\n 5 seconds\nKeep tapping !";
    startlabel.numberOfLines = 4;
    startlabel.textAlignment = NSTextAlignmentCenter;
    startlabel.font = [UIFont boldSystemFontOfSize:35];
    startlabel.tintColor = [UIColor blackColor];
    [mStartupDialogue addSubview:startlabel];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(startlabel);
    
    NSArray *lhorizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[startlabel]-20-|" options:0 metrics:nil views:views];
    NSArray *verticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[startlabel]-20-|" options:0 metrics:nil views:views];
    
    [mStartupDialogue addConstraints:verticalConstraints];
    [mStartupDialogue addConstraints:lhorizontalConstraints];
    
    mStartTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(startupTimer)
                                                 userInfo:nil
                                                  repeats:YES];
    mStartupCounter = 5;
}

-(void)startupTimer
{
    mStartupCounter = mStartupCounter - 1;
    startlabel.text = [NSString stringWithFormat:@"The Dance\nStarts in\n %ld seconds\nKeep tapping !", mStartupCounter];
    if (mStartupCounter == 0)
    {
        [mStartTimer invalidate];
        mStartupDialogue.hidden = YES;
        // Start with level 1
        [self play:1];
    }
}

-(void)youLooser
{
    mLooserDialogue = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 150,25,300,300)];
    mLooserDialogue.layer.borderColor = [UIColor blackColor].CGColor;
    mLooserDialogue.layer.cornerRadius = 10.0f;
    mLooserDialogue.layer.borderWidth = 3.0f;
    mLooserDialogue.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mLooserDialogue];
    
    UILabel* label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.text = @"HAHA ! Looser !";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:35];
    label.tintColor = [UIColor blackColor];
    [mLooserDialogue addSubview:label];
    
    UIButton* button =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setTitle:@"Replay!" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont: [button.titleLabel.font fontWithSize:30]];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 2.f;
    button.layer.cornerRadius = 20.f;
    [button addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    [mLooserDialogue addSubview:button];
    
    pbutton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pbutton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [pbutton setTitle:@"Previous lvl ;-(" forState:UIControlStateNormal];
    [pbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [pbutton.titleLabel setFont: [button.titleLabel.font fontWithSize:30]];
    pbutton.layer.borderColor = [UIColor blackColor].CGColor;
    pbutton.layer.borderWidth = 2.f;
    pbutton.layer.cornerRadius = 20.f;
    [pbutton addTarget:self action:@selector(previousPlay) forControlEvents:UIControlEventTouchUpInside];
    [mLooserDialogue addSubview:pbutton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(label, pbutton, button);
    
    NSArray *lhorizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label]-20-|" options:0 metrics:nil views:views];
    NSArray *bhorizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[button]-20-|" options:0 metrics:nil views:views];
    NSArray *phorizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[pbutton]-20-|" options:0 metrics:nil views:views];
    NSArray *verticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[label]-20-[pbutton]-20-[button]-20-|" options:0 metrics:nil views:views];
    
    [mLooserDialogue addConstraints:verticalConstraints];
    [mLooserDialogue addConstraints:bhorizontalConstraints];
    [mLooserDialogue addConstraints:phorizontalConstraints];
    [mLooserDialogue addConstraints:lhorizontalConstraints];
}

-(void)youWinner
{
    mWinnerDialogue = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 150,25,300,300)];
    mWinnerDialogue.layer.borderColor = [UIColor blackColor].CGColor;
    mWinnerDialogue.layer.cornerRadius = 10.0f;
    mWinnerDialogue.layer.borderWidth = 3.0f;
    mWinnerDialogue.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mWinnerDialogue];
    
    UILabel* label = [[UILabel alloc] init];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    label.text = @"You Won !";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:35];
    label.tintColor = [UIColor blackColor];
    [mWinnerDialogue addSubview:label];
    
    UIButton* nbutton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [nbutton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [nbutton setTitle:@"Next lvl!" forState:UIControlStateNormal];
    [nbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [nbutton.titleLabel setFont: [nbutton.titleLabel.font fontWithSize:30]];
    nbutton.layer.borderColor = [UIColor blackColor].CGColor;
    nbutton.layer.borderWidth = 2.f;
    nbutton.layer.cornerRadius = 20.f;
    [nbutton addTarget:self action:@selector(nextPlay) forControlEvents:UIControlEventTouchUpInside];
    [mWinnerDialogue addSubview:nbutton];
    
    UIButton* rbutton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rbutton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rbutton setTitle:@"Replay" forState:UIControlStateNormal];
    [rbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rbutton.titleLabel setFont: [rbutton.titleLabel.font fontWithSize:30]];
    rbutton.layer.borderColor = [UIColor blackColor].CGColor;
    rbutton.layer.borderWidth = 2.f;
    rbutton.layer.cornerRadius = 20.f;
    [rbutton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    [mWinnerDialogue addSubview:rbutton];
    
    UIButton* sbutton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sbutton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [sbutton setTitle:@"Share" forState:UIControlStateNormal];
    [sbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sbutton.titleLabel setFont: [rbutton.titleLabel.font fontWithSize:30]];
    sbutton.layer.borderColor = [UIColor blackColor].CGColor;
    sbutton.layer.borderWidth = 2.f;
    sbutton.layer.cornerRadius = 20.f;
    [sbutton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [mWinnerDialogue addSubview:sbutton];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(label, nbutton, rbutton, sbutton);
    
    NSArray *lhorizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[label]-20-|" options:0 metrics:nil views:views];
    NSArray *bhorizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[nbutton]-20-|" options:0 metrics:nil views:views];
    NSArray *rhorizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[rbutton]-20-|" options:0 metrics:nil views:views];
    NSArray *shorizontalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[sbutton]-20-|" options:0 metrics:nil views:views];
    NSArray *verticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[label]-20-[nbutton]-20-[rbutton]-20-[sbutton]-20-|" options:0 metrics:nil views:views];
    
    [mWinnerDialogue addConstraints:verticalConstraints];
    [mWinnerDialogue addConstraints:bhorizontalConstraints];
    [mWinnerDialogue addConstraints:rhorizontalConstraints];
    [mWinnerDialogue addConstraints:shorizontalConstraints];
    [mWinnerDialogue addConstraints:lhorizontalConstraints];
}

-(void)share
{
    // Facebook share
    NSString* text= [NSString stringWithFormat:@"I won Aikikoator in %ld lvl", mLevel];
    //NSURL *myWebsite = [NSURL URLWithString:@"http://www.website.com/"];
    //  UIImage * myImage =[UIImage imageNamed:@"myImage.png"];
    NSArray* sharedObjects=@[text, mScreeshot];
    UIActivityViewController * activityViewController=[[UIActivityViewController alloc]initWithActivityItems:sharedObjects applicationActivities:nil];
    
    activityViewController.popoverPresentationController.sourceView = self.view;
    [self.view.window.rootViewController presentViewController:activityViewController animated:YES completion:nil];
}

-(void)takeScreenshot
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    mScreeshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


-(void)replay
{
    // Hide the dialogues
    mLooserDialogue.hidden = YES;
    mWinnerDialogue.hidden = YES;
    // Replay with the current level
    [self play:mLevel];
}

-(void)nextPlay
{
    // Hide the dilogues
    mWinnerDialogue.hidden = YES;
    mLooserDialogue.hidden = YES;
    
    // Increase the difficulty level
    [self play:mLevel + 1];
}

-(void)previousPlay
{
    // Hide the dilogues
    mWinnerDialogue.hidden = YES;
    mLooserDialogue.hidden = YES;
    
    if (mLevel > 1)
    {
        // Decrease the difficulty level
        mLevel = mLevel - 1;
    }
    [self play:mLevel];
}

@end
