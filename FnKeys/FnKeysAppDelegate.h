@interface FnKeysAppDelegate : NSObject {
    NSStatusItem * statusItem;
    IBOutlet NSMenu *theMenu;
    NSMenuItem *ipMenuItem;
}

-(IBAction)toogleFnKeys:(id)sender;

@end