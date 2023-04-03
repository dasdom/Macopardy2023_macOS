//  Created by Dominik Hauser on 03.04.23.
//  
//

#import "AppDelegate.h"
#import "GameViewController.h"

@interface AppDelegate ()
@property (strong) NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    GameViewController *gameViewController = [[GameViewController alloc] init];
    gameViewController.title = @"Macopardy";
    
    NSWindow *window = [NSWindow windowWithContentViewController:gameViewController];
    [window makeKeyAndOrderFront:self];
    self.window = window;
}

@end
