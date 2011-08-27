#import "FnKeysAppDelegate.h"

@implementation FnKeysAppDelegate

NSString * const off = @"\u263c";
NSString * const on = @"Fn";

-(void)dealloc
{
    [statusItem release];
    [super dealloc];
}

-(void)awakeFromNib
{
    statusItem = [[[NSStatusBar systemStatusBar] 
                   statusItemWithLength:NSVariableStatusItemLength]
                  retain]; 
    [statusItem setEnabled:YES];    
    [statusItem setAction:@selector(toogleFnKeys:)];
    [statusItem setTarget:self];
    
    CFPropertyListRef val = CFPreferencesCopyAppValue(CFSTR("com.apple.keyboard.fnState"), kCFPreferencesCurrentUser);
    Boolean fnFlag = false;
    if(val) {
        fnFlag = CFBooleanGetValue(val);
        NSLog(@"fnFlag %d", fnFlag);
        if (fnFlag) {        
            [statusItem setTitle:on];            
        } else {
            [statusItem setTitle:off];
        }
        CFRelease(val);
    }
}

-(IBAction)toogleFnKeys:(id)sender
{
//    run the script first
    NSString* path = [[NSBundle mainBundle] pathForResource:@"FnKeys" ofType:@"scpt"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSDictionary* errors = [NSDictionary dictionary];
    NSAppleScript* appleScript = [[NSAppleScript alloc] initWithContentsOfURL:url error:&errors];
    [appleScript executeAndReturnError:nil];
    [appleScript release];

    sleep(1);
    
//    then update the icon
    Boolean fnFlag = false;

    NSLog(@"synchronized %d", CFPreferencesAppSynchronize(CFSTR("com.apple.keyboard.fnState")));

    CFPropertyListRef val = CFPreferencesCopyAppValue(CFSTR("com.apple.keyboard.fnState"), kCFPreferencesCurrentUser);
    
//    NSLog(@"managed by MCX %d", CFPreferencesAppValueIsForced(CFSTR("com.apple.keyboard.fnState"), kCFPreferencesCurrentUser));

    NSLog(@"val %@", val);
    
    if(val) {
        fnFlag = CFBooleanGetValue(val);
        NSLog(@"fnFlag %d", fnFlag);
        
//        this doesn't work as System Pref loads the plist file only on login        
//                CFPreferencesSetValue(CFSTR("com.apple.keyboard.fnState"), 
//                                      (CFBooleanRef)[NSNumber numberWithBool:fnFlag], 
//                                      kCFPreferencesAnyApplication, 
//                                      kCFPreferencesCurrentUser, 
//                                      kCFPreferencesCurrentHost);
        
        if (fnFlag) {        
            [statusItem setTitle:on];            
        } else {
            [statusItem setTitle:off];
        }
        CFRelease(val);
    }
    
//    NSLog(@"synchronized %d", CFPreferencesAppSynchronize(CFSTR("com.apple.keyboard.fnState")));
}

@end