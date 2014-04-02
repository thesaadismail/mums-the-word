//
//  MasterViewController.m
//  mums-the-word
//
//  Created by Saad Ismail on 3/29/14.
//  Copyright (c) 2014 squarestaq. All rights reserved.
//

#import "MasterViewController.h"
#import "AppDelegate.h"
#import "MTWHotkey.h"
#import "MASShortcutView.h"
#import "MASShortcutView+UserDefaults.h"

#define OptionsList_SelectShortcutKey "Select Shortcut Key"
#define OptionsList_ControlKey "Control Key"
#define OptionsList_OptionKey "Options Key"
#define OptionsList_CommandKey "Command Key"
#define OptionsList_CustomCombination "Custom Combination"


@interface MasterViewController ()
{
    NSStatusItem * statusItem;
    BOOL mtwEnabled;
    
    //NSInteger selectedOption;
    NSMutableArray *menuItems;
}
@property (weak) IBOutlet NSTextField *labelStatus;
@property (weak) IBOutlet NSButton *buttonEnable;
@property (weak) IBOutlet NSPopUpButton *optionsList;
@property (nonatomic, weak) IBOutlet MASShortcutView *shortcutView;
@end

@implementation MasterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        // Assign the preference key and the shortcut view will take care of persistence
        self.shortcutView.associatedUserDefaultsKey = [MTWHotkey getGlobalPreferenceShortcut];
        mtwEnabled = NO;
        [self setupMenuItemsArray];
    }
    return self;
}

- (void)awakeFromNib
{
    AppDelegate *delegate = (AppDelegate *)[NSApplication sharedApplication].delegate;
    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:delegate.statusBarMenu];
    [statusItem setTitle:@"MTW"];
    [statusItem setHighlightMode:YES];
    
    [self.labelStatus setStringValue:@"Status: MTW is disabled."];
    
    for(NSMenuItem *menuItem in menuItems)
    {
        [self.optionsList.menu addItem:menuItem];
    }
    
    [[self.optionsList menu] setDelegate:self];
    
    [self.shortcutView setHidden:YES];
}

-(void)setupMenuItemsArray
{
    menuItems = [[NSMutableArray alloc] init];
    
    NSMenuItem *controlMenuItem = [[NSMenuItem alloc] init];
    controlMenuItem.title = @"Control Key";
    controlMenuItem.tag = MenuItem_ControlKey;
    [menuItems addObject:controlMenuItem];
    
    NSMenuItem *optionsMenuItem = [[NSMenuItem alloc] init];
    optionsMenuItem.title = @"Option Key";
    optionsMenuItem.tag = MenuItem_OptionKey;
    [menuItems addObject:optionsMenuItem];
    
    NSMenuItem *commandMenuItem = [[NSMenuItem alloc] init];
    commandMenuItem.title = @"Command Key";
    commandMenuItem.tag = MenuItem_CommandKey;
    [menuItems addObject:commandMenuItem];
    
    NSMenuItem *customCombinationMenyItem = [[NSMenuItem alloc] init];
    customCombinationMenyItem.title = @"Custom Combination";
    customCombinationMenyItem.tag = MenuItem_CustomCombination;
    [menuItems addObject:customCombinationMenyItem];
}

#pragma mark Button Actions
- (IBAction)toggleMTWAction:(id)sender
{
    mtwEnabled = !mtwEnabled;
    if(mtwEnabled)
    {
        [self.labelStatus setStringValue:@"Status: MTW is enabled."];
        [self.buttonEnable setTitle:@"Disable"];
        [[MTWHotkey sharedInstance] registerHotkey:self.shortcutView.shortcutValue];
    }
    else
    {
        [self.labelStatus setStringValue:@"Status: MTW is disabled."];
        [self.buttonEnable setTitle:@"Enable"];
        [[MTWHotkey sharedInstance] unregisterHotkey];
    }
}

#pragma mark NSMenu Actions
- (IBAction)shortcutOptionsAction:(NSPopUpButton *)sender {
    NSLog(@"User Selected Menu Item: %@", sender.selectedItem.title);
    [MTWHotkey sharedInstance].selectedHotkey = sender.selectedItem.tag;
    switch(sender.selectedItem.tag)
    {
        case MenuItem_ControlKey:
            [self.shortcutView setHidden:YES];
            break;
        case MenuItem_OptionKey:
            [self.shortcutView setHidden:YES];
            break;
        case MenuItem_CommandKey:
            [self.shortcutView setHidden:YES];
            break;
        case MenuItem_CustomCombination:
            [self.shortcutView setHidden:NO];
            break;
        default:
            [self.shortcutView setHidden:YES];
            break;
    }
    
    //if mtw is already enabled and the user has changed the hotkey, then disable mtw
    if(mtwEnabled)
       [self toggleMTWAction:nil];
}

@end