//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "NSWindowController.h"

#import "NSToolbarDelegate.h"

@class MSPluginManager, MSPreferencePane, NSArray, NSCache, NSDictionary, NSString, NSToolbar;

@interface MSPreferencesController : NSWindowController <NSToolbarDelegate>
{
    MSPluginManager *_pluginManager;
    NSArray *_toolbarItemIdentifiers;
    NSDictionary *_preferencePaneClasses;
    NSCache *_preferencePanes;
    MSPreferencePane *_currentPreferencePane;
    NSToolbar *_toolbar;
}

+ (id)sharedController;

- (void)adjustColorsAction:(id)arg1;
- (void)awakeFromNib;
@property(retain, nonatomic) MSPreferencePane *currentPreferencePane; // @synthesize currentPreferencePane=_currentPreferencePane;
@property(retain, nonatomic) MSPluginManager *pluginManager; // @synthesize pluginManager=_pluginManager;
@property(copy, nonatomic) NSDictionary *preferencePaneClasses; // @synthesize preferencePaneClasses=_preferencePaneClasses;
@property(retain, nonatomic) NSCache *preferencePanes; // @synthesize preferencePanes=_preferencePanes;
- (void)scaleDownForRetinaAction:(id)arg1;
@property(nonatomic) unsigned long long selectedTabIndex;
@property(nonatomic) __weak NSToolbar *toolbar; // @synthesize toolbar=_toolbar;
@property(copy, nonatomic) NSArray *toolbarItemIdentifiers; // @synthesize toolbarItemIdentifiers=_toolbarItemIdentifiers;
- (void)switchPanes:(id)arg1;
- (void)switchToPaneWithIdentifier:(id)arg1;
- (id)toolbar:(id)arg1 itemForItemIdentifier:(id)arg2 willBeInsertedIntoToolbar:(BOOL)arg3;
- (id)toolbarAllowedItemIdentifiers:(id)arg1;
- (id)toolbarDefaultItemIdentifiers:(id)arg1;
- (id)toolbarSelectableItemIdentifiers:(id)arg1;
- (BOOL)validateToolbarItem:(id)arg1;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end
