//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "MSEventHandler.h"

#import "NSMenuDelegate.h"
#import "NSTextDelegate.h"

@class MSLayerGroup, MSSelectionPath, MSSelectionPathCollection, MSShapePathLayer, NSArray, NSButton, NSPopUpButton, NSSlider, NSString, NSTextField, NSView;

@interface MSShapeEventHandler : MSEventHandler <NSTextDelegate, NSMenuDelegate>
{
    MSSelectionPathCollection *selectionPaths;
    MSSelectionPathCollection *dragRectSelection;
    long long hoveringPoint;
    long long hoveringPointInPoint;
    long long hoveringBeforePointIndex;
    BOOL firstDrag;
    BOOL editingNewShape;
    BOOL didInsertOnMouseDown;
    BOOL didSelectPoints;
    BOOL didMouseDown;
    BOOL wasMakingDragRectSelectionAtMouseDown;
    struct CGPoint mouseLocation;
    struct CGPoint lastMouseMoved;
    struct CGPoint selectionStartPoint;
    struct CGPoint selectionEndPoint;
    NSTextField *cornerRadiusField;
    NSPopUpButton *roundingPopUpButton;
    NSView *curveModeBackgroundView;
    NSButton *makeRectSelectionButton;
    NSButton *closePathButton;
    NSTextField *curvePointXField;
    NSTextField *curvePointYField;
    NSSlider *cornerRadiusSlider;
    struct CGRect dirtyRect;
    BOOL _isMakingRectSelection;
    BOOL _hideEditingPoints;
    id _horizontalSnap;
    id _verticalSnap;
    MSSelectionPath *_candidateSelection;
    MSLayerGroup *_currentGroup;
    MSShapePathLayer *_shape;
    MSSelectionPathCollection *_snappedPaths;
}


- (struct CGPoint)_roundPoint:(struct CGPoint)arg1;
- (BOOL)absoluteMouseDragged:(struct CGPoint)arg1 flags:(unsigned long long)arg2;
- (void)addPointForMouse:(struct CGPoint)arg1;
- (void)adjustCurrentCurveXYValue;
- (void)adjustFrame;
- (struct CGPoint)adjustPoint:(struct CGPoint)arg1 toLayer:(id)arg2;
- (void)adjustRoundingPopUpTitle;
- (void)adjustSelectedPointOnAxis:(unsigned long long)arg1;
- (struct CGPoint)alignPoint:(struct CGPoint)arg1 withShiftTo:(struct CGPoint)arg2;
- (void)alignSelectedPointsToValue:(double)arg1 axis:(unsigned long long)arg2;
- (void)alignVectorPointsToKey:(id)arg1;
- (void)awakeFromNib;
- (id)bezierPathAroundPoint:(id)arg1 andPoint:(id)arg2 xTol:(double)arg3 yTol:(double)arg4;
- (id)bezierPathForWire;
- (id)bezierWireForClosingPath;
- (BOOL)canAddNewPointOnMouseDownWithFlags:(unsigned long long)arg1;
@property(retain, nonatomic) MSSelectionPath *candidateSelection; // @synthesize candidateSelection=_candidateSelection;
- (void)changeColor:(id)arg1;
- (void)changeFromStraightToMirrored:(id)arg1 index:(long long)arg2;
- (void)changeSelectedCurvePointsTo:(long long)arg1;
- (struct CGPoint)checkForPoint:(struct CGPoint)arg1 againstPoint:(struct CGPoint)arg2 path:(id)arg3;
- (void)clearSelectionPathsAndRefresh;
- (struct MSShapeClickInfo)clickInfoForMouse:(struct CGPoint)arg1;
- (void)closePathAction:(id)arg1;
- (void)cornerRadiusAction:(id)arg1;
@property(nonatomic) __weak MSLayerGroup *currentGroup; // @synthesize currentGroup=_currentGroup;
- (long long)curveModeForPressedKey:(long long)arg1;
- (id)curvePointForSelectionPath:(id)arg1;
- (void)curvePointXAction:(id)arg1;
- (void)curvePointYAction:(id)arg1;
- (void)dealloc;
- (id)defaultCursor;
- (void)delete:(id)arg1;
- (void)deleteSelectedPoints;
- (void)determineSelectedPointsByDrag;
- (BOOL)didClickOutsideBounds:(struct CGPoint)arg1;
- (void)didUndoNotification:(id)arg1;
- (struct CGRect)dirtyFrame;
- (void)distributePointsOnPaths:(id)arg1 alongAxis:(unsigned long long)arg2;
- (void)distributeVectorPointsToAxis:(unsigned long long)arg1;
- (void)drawInRect:(struct CGRect)arg1;
- (void)drawSnaps;
- (void)drawVectorSelection:(id)arg1;
- (void)drawWire;
- (void)duplicate:(id)arg1;
- (void)expandHandlesForSelectedPoint;
- (void)expandHandlesForSelectionPath:(id)arg1;
- (id)findSelectedShape;
- (void)finishEditingAction:(id)arg1;
- (void)fitCurvePoint:(id)arg1 bySplittingCurvePath:(id)arg2 surroundingPoints:(id)arg3;
- (void)flagsChanged:(id)arg1;
- (void)gradientHandlerDidFocus:(id)arg1;
- (void)gradientHandlerWillLoseFocus:(id)arg1;
- (void)handlerGotFocus;
- (void)handlerWillLoseFocus;
@property(nonatomic) BOOL hideEditingPoints; // @synthesize hideEditingPoints=_hideEditingPoints;
@property(retain, nonatomic) id horizontalSnap; // @synthesize horizontalSnap=_horizontalSnap;
- (long long)indexOfSelectedPoint;
- (id)initWithManager:(id)arg1;
- (void)insertBacktab:(id)arg1;
- (void)insertNewShapeForEditingAtPoint:(struct CGPoint)arg1;
- (void)insertPoint:(struct CGPoint)arg1 beforeIndex:(long long)arg2;
- (void)insertTab:(id)arg1;
- (unsigned long long)inspectorLocation;
- (BOOL)inspectorShouldShowBlendingProperties;
- (BOOL)inspectorShouldShowLayerSpecificProperties;
- (BOOL)inspectorShouldShowPositions;
- (BOOL)inspectorShouldShowSharedStyles;
@property(nonatomic) BOOL isMakingRectSelection; // @synthesize isMakingRectSelection=_isMakingRectSelection;
- (void)keyDown:(unsigned short)arg1 flags:(unsigned long long)arg2;
- (void)keyUp:(unsigned short)arg1 flags:(unsigned long long)arg2;
- (id)layersToCopy;
- (void)markShapeDirtyOfType:(unsigned long long)arg1;
- (void)menuNeedsUpdate:(id)arg1;
- (BOOL)mouseDown:(struct CGPoint)arg1 clickCount:(unsigned long long)arg2 flags:(unsigned long long)arg3;
- (BOOL)mouseDownEvent:(id)arg1;
- (BOOL)mouseDragged:(struct CGPoint)arg1 flags:(unsigned long long)arg2;
- (BOOL)mouseMoved:(struct CGPoint)arg1 flags:(unsigned long long)arg2;
- (BOOL)mouseUp:(struct CGPoint)arg1 flags:(unsigned long long)arg2;
- (id)nibName;
- (void)nudgeSelectedPointsForKey:(unsigned short)arg1 flags:(unsigned long long)arg2;
- (BOOL)point:(struct CGPoint)arg1 isBetweenPoint:(id)arg2 andPoint:(id)arg3;
- (BOOL)point:(struct CGPoint)arg1 isCloseToPoint:(struct CGPoint)arg2;
- (struct CGPoint)pointFromRootCoordinatesToRelativeToBounds:(struct CGPoint)arg1;
- (struct CGPoint)pointInRootCoordinates:(struct CGPoint)arg1;
- (struct CGPoint)pointValueForSelectionPath:(id)arg1;
- (id)pointsAroundIndex:(long long)arg1;
- (void)prepareShapeForEditing;
- (struct CGRect)rectOfSelectedPoints;
- (void)refreshAction:(id)arg1;
- (void)refreshDragRect;
- (void)refreshWireIfNecessary;
- (struct CGPoint)relativePoint:(struct CGPoint)arg1;
- (void)reloadViewData;
- (struct CGPoint)roundPoint:(struct CGPoint)arg1;
- (void)roundingPopUpAction:(id)arg1;
- (void)selectAll:(id)arg1;
- (void)selectPointAndUpdate:(long long)arg1 curve:(long long)arg2;
- (void)selectPointValueForField:(id)arg1 onAxis:(unsigned long long)arg2;
@property(readonly, nonatomic) __weak NSArray *selectedCurvePoints; // @dynamic selectedCurvePoints;
- (id)selectedPathsSortedByAxis:(unsigned long long)arg1;
- (BOOL)selectingPointShouldClosePath:(long long)arg1;
- (id)selectionPaths;
- (void)setPoint:(struct CGPoint)arg1 forSelectionPath:(id)arg2;
@property(retain, nonatomic) MSShapePathLayer *shape; // @synthesize shape=_shape;
@property(retain, nonatomic) MSSelectionPathCollection *snappedPaths; // @synthesize snappedPaths=_snappedPaths;
@property(retain, nonatomic) id verticalSnap; // @synthesize verticalSnap=_verticalSnap;
- (BOOL)shouldDrawLayerSelection;
- (BOOL)shouldHideExportBar;
- (void)showCursorWithFlags:(unsigned long long)arg1;
- (struct CGPoint)snapPoint:(struct CGPoint)arg1;
- (struct CGPoint)snapPointIfEnabled:(struct CGPoint)arg1;
- (void)snapsMouseUpHook;
- (id)titleForRoundingPopUp;
- (id)toolbarIdentifier;
- (void)validateCornerRadiusButton;
- (void)vectorModeSegmentedButtonAction:(id)arg1;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end

