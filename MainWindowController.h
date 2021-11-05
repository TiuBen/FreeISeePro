//
//  MainWindowController.h
//  Free_I_See
//
//  Created by shen ning on 2021/10/28.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainWindowController : NSWindowController<NSToolbarDelegate>

@property (nonatomic,strong) NSMutableArray *selectedFiles;
@property  Boolean skipSubfiles;
@property (nonatomic,strong) NSArray *allowedFileTypes;

- (IBAction)toolbarItemClicked:(id)sender;

@end

NS_ASSUME_NONNULL_END
