//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "MSStylePartInspectorViewController.h"

@class MSShareButtonHandler, NSArray, NSButton, NSView;

@interface MSExportInspectorViewController : MSStylePartInspectorViewController
{
    NSArray *_layers;
    NSView *_topFillerView;
    NSView *_bottomLabelView;
    NSView *_exportButtonView;
    NSView *_separatorView;
    NSView *_separatorView2;
    NSView *_bigExportLabel;
    NSButton *_addExportSizeButton;
    NSButton *_shareButton;
    NSButton *_exportButton;
    NSButton *_knifeButton;
    NSArray *_sizeViewControllers;
    MSShareButtonHandler *_shareButtonHandler;
}


- (void)addExportSize:(id)arg1;
@property(retain, nonatomic) NSButton *addExportSizeButton; // @synthesize addExportSizeButton=_addExportSizeButton;
- (void)applyDisplayNameToExportButton;
- (void)awakeFromNib;
@property(retain, nonatomic) NSView *bigExportLabel; // @synthesize bigExportLabel=_bigExportLabel;
@property(retain, nonatomic) NSView *bottomLabelView; // @synthesize bottomLabelView=_bottomLabelView;
- (void)createSliceAction:(id)arg1;
- (void)dealloc;
- (id)document;
@property(retain, nonatomic) NSButton *exportButton; // @synthesize exportButton=_exportButton;
- (id)exportButtonDisplayName;
@property(retain, nonatomic) NSView *exportButtonView; // @synthesize exportButtonView=_exportButtonView;
- (void)exportSingleSlice:(id)arg1;
- (BOOL)hasEnabledStyle;
@property(retain, nonatomic) NSButton *knifeButton; // @synthesize knifeButton=_knifeButton;
@property(copy, nonatomic) NSArray *layers; // @synthesize layers=_layers;
- (void)observeValueForKeyPath:(id)arg1 ofObject:(id)arg2 change:(id)arg3 context:(void *)arg4;
- (void)prepare;
- (void)prepareForDisplay;
@property(retain, nonatomic) NSView *separatorView; // @synthesize separatorView=_separatorView;
@property(retain, nonatomic) NSView *separatorView2; // @synthesize separatorView2=_separatorView2;
@property(retain, nonatomic) NSButton *shareButton; // @synthesize shareButton=_shareButton;
@property(retain, nonatomic) MSShareButtonHandler *shareButtonHandler; // @synthesize shareButtonHandler=_shareButtonHandler;
@property(copy, nonatomic) NSArray *sizeViewControllers; // @synthesize sizeViewControllers=_sizeViewControllers;
@property(retain, nonatomic) NSView *topFillerView; // @synthesize topFillerView=_topFillerView;
- (void)shareAction:(id)arg1;
- (id)view;
- (id)views;
- (BOOL)wantsSeparatorBetweenView:(id)arg1 andView:(id)arg2;

@end

