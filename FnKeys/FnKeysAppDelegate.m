#import "FnKeysAppDelegate.h"

@implementation FnKeysAppDelegate

NSString * const off = @"\u2718";
NSString * const on = @"\u2714";

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
    [statusItem setTitle:off]; 
    [statusItem setEnabled:YES];    
    [statusItem setAction:@selector(toogleFnKeys:)];
    [statusItem setTarget:self];
}

-(IBAction)toogleFnKeys:(id)sender
{
    Boolean fnFlag = false;
//    CFStringRef appID = CFSTR("com.apple.keyboard");
//    CFStringRef key = CFSTR("fnState");

    NSLog(@"synchronized %d", CFPreferencesAppSynchronize(CFSTR("com.apple.keyboard.fnState")));

    CFPropertyListRef val = CFPreferencesCopyAppValue(CFSTR("com.apple.keyboard.fnState"), kCFPreferencesCurrentUser);
    
    NSLog(@"managed by MCX %d", CFPreferencesAppValueIsForced(CFSTR("com.apple.keyboard.fnState"), kCFPreferencesCurrentUser));

    NSLog(@"val %@", val);
    
    if(val) {
        fnFlag = CFBooleanGetValue(val);
        NSLog(@"fnFlag %d", fnFlag);
        
                
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
    
    NSLog(@"synchronized %d", 
          CFPreferencesAppSynchronize(CFSTR("com.apple.keyboard.fnState")));
}

@end