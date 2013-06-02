//
//  EPGProgrammViewController.m
//  KartinaX.TV
//
//  Created by mk on 30.05.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "EPGProgrammViewController.h"
#import "KartinaSession.h"
#import "KartinaClient.h"
#import "Show.h"
#import "PlaybackItem.h"
#import "ChannelGroup.h"
#import "Utils.h"
#import "ChannelList.h"
#import "EPGData.h"


@interface EPGProgrammViewController ()

@end

@implementation EPGProgrammViewController

NSViewController *_sharedShowPreviewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    [super loadView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(epgLoaded:)
                                                 name:kEPGLoadSuccessfulNotification
                                               object:nil];
}


- (void)awakeFromNib {

    [super awakeFromNib];

    self.datePicker.dateValue = [NSDate date];
    [self.datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    [self.datePickerCell sendActionOn:NSLeftMouseDown];

    [self.epgBrowser setAction:@selector(_browserClicked:)];
    [self.epgBrowser setDoubleAction:@selector(_browserDblClicked:)];
    [self.epgBrowser setTarget:self];
    [self.epgBrowser setAutohidesScroller:YES];
}


- (void)epgLoaded:(NSNotification *)notification {
    [self.parentController stopLoadingIndicator];
    [self.datePicker setEnabled:YES];
    [self.epgBrowser reloadColumn:2];
}


- (IBAction)epgDateSelected:(id)sender {
    [self.parentController startLoadingIndicator];
    [self.datePicker setEnabled:NO];
    KartinaClient *client = [KartinaClient sharedInstance];
    [client loadEPG:self.datePicker.dateValue];
}

- (void)selectCurrentShow {

    self.datePicker.dateValue = [NSDate date];

    PlaybackItem *currentPlaybackItem = [KartinaSession currentPlaybackItem];

    ChannelList *channelList = [KartinaSession channelList];
    ChannelGroup *g;
    Channel *c;

    NSUInteger count = [channelList.channelGroups count];
    for (NSUInteger i = 0; i < count; i++) {
        g = [channelList.channelGroups objectAtIndex:i];
        if ([currentPlaybackItem.groupName isEqualToString:g.name]) {
            [self.epgBrowser selectRow:i inColumn:0];
            break;
        }
    }

    count = [g.channels count];
    for (NSUInteger i = 0; i < count; i++) {
        c = [g.channels objectAtIndex:i];
        if ([currentPlaybackItem.channelName isEqualToString:c.name]) {
            [self.epgBrowser selectRow:i inColumn:1];
            break;
        }
    }

    EPGData *epgData = [KartinaSession epgDataForDate:self.datePicker.dateValue];
    EPGDataItem *item = [epgData itemForChannel:c.id];

    count = [item.shows count];
    for (NSUInteger i = 0; i < count; i++) {
        Show *show = [item.shows objectAtIndex:i];
        if ([currentPlaybackItem.name isEqualToString:show.name] && [currentPlaybackItem.start isEqualToNumber:show.start]) {
            [self.epgBrowser selectRow:i inColumn:2];
            break;
        }
    }

}


- (void)_browserClicked:(id)sender {

    NSIndexPath *selectionIndexPath = [self.epgBrowser selectionIndexPath];
    if (selectionIndexPath.length > 0) {
        // Auto select a leaf item, but maintain the first responder
        /*
        if (![self.browser isLeafItem:[self.browser itemAtIndexPath:selectionIndexPath]]) {
            NSResponder *firstResponder = [self.browser.window.firstResponder retain];
            NSIndexPath *indexPathForLastColumn = [self.browser indexPathForColumn:self.browser.lastColumn];
            NSIndexPath *firstRowInLastColumn = [indexPathForLastColumn indexPathByAddingIndex:0];
            [self.browser setSelectionIndexPath:firstRowInLastColumn];
            [self.browser.window makeFirstResponder:firstResponder];
            [firstResponder release];
            // Also attempt to keep it scrolled into view
            [self.browser scrollColumnToVisible:self.browser.lastColumn];
        }
         */
    }
}


- (void)_browserDblClicked:(id)sender {

    NSIndexPath *selectionIndexPath = [self.epgBrowser selectionIndexPath];
    if (selectionIndexPath.length > 0) {

        id item = [self.epgBrowser itemAtIndexPath:selectionIndexPath];

        PlaybackItem *playbackItem = nil;

        if ([item isMemberOfClass:[Channel class]]) {
            // channel double-clicked.. play current live show..
            Channel *channel = (Channel *) item;
            playbackItem = [[PlaybackItem alloc] initWithName:channel.epgProgname
                                                        start:channel.epgStart end:channel.epgEnd
                                        playbackStartPosition:nil
                                                      groupId:channel.groupId groupName:channel.groupName
                                                    channelId:channel.id channelName:channel.name
                                             protectedChannel:channel.isProtected];

        } else if ([item isMemberOfClass:[Show class]]) {

            Show *show = (Show *) item;
            Channel *channel = (Channel *) [self.epgBrowser parentForItemsInColumn:[self.epgBrowser selectedColumn]];


            if (show.isLessThan30MinOld) {

                playbackItem = [[PlaybackItem alloc] initWithName:show.name
                                                            start:show.start end:show.end
                                            playbackStartPosition:nil
                                                          groupId:channel.groupId groupName:channel.groupName
                                                        channelId:channel.id channelName:channel.name
                                                 protectedChannel:channel.isProtected];

            } else if (channel.hasArchive && show.isInArchiveRange) {

                playbackItem = [[PlaybackItem alloc] initWithName:show.name
                                                            start:show.start end:show.end playbackStartPosition:show.start
                                                          groupId:channel.groupId groupName:channel.groupName
                                                        channelId:channel.id channelName:channel.name
                                                 protectedChannel:channel.isProtected];

            }


        }

        if (playbackItem != nil) {
            [[NSNotificationCenter defaultCenter]
                    postNotificationName:kPlaybackItemSelectedNotification
                                  object:self
                                userInfo:@{@"playbackItem" : playbackItem}
            ];
        }


    }
}


- (id)rootItemForBrowser:(NSBrowser *)browser {
    return [KartinaSession channelList];
}

- (NSInteger)browser:(NSBrowser *)browser numberOfChildrenOfItem:(id)item {

    if ([item isMemberOfClass:[ChannelList class]]) {
        return [[((ChannelList *) item) channelGroups] count];
    }

    if ([item isMemberOfClass:[ChannelGroup class]]) {
        return [[((ChannelGroup *) item) channels] count];
    }

    if ([item isMemberOfClass:[Channel class]]) {
        EPGData *epgData = [KartinaSession epgDataForDate:self.datePicker.dateValue];
        EPGDataItem *epgDataItem = [epgData itemForChannel:((Channel *) item).id];
        if (epgDataItem != nil && epgDataItem.shows != nil)
            return [epgDataItem.shows count];
    }

    if ([item isMemberOfClass:[Show class]]) {
        return 1;
    }

    return 0;
}

- (id)browser:(NSBrowser *)browser child:(NSInteger)index ofItem:(id)item {

    if ([item isMemberOfClass:[ChannelList class]]) {
        return (ChannelList *) [[item channelGroups] objectAtIndex:(NSUInteger) index];
    }

    if ([item isMemberOfClass:[ChannelGroup class]]) {
        return (ChannelGroup *) [[item channels] objectAtIndex:(NSUInteger) index];
    }

    if ([item isMemberOfClass:[Channel class]]) {
        EPGData *epgData = [KartinaSession epgDataForDate:self.datePicker.dateValue];
        EPGDataItem *epgDataItem = [epgData itemForChannel:((Channel *) item).id];
        if (epgDataItem != nil && epgDataItem.shows != nil)
            return [epgDataItem.shows objectAtIndex:(NSUInteger) index];
    }

    return nil;
}

- (BOOL)browser:(NSBrowser *)browser isLeafItem:(id)item {
    if ([item isMemberOfClass:[Show class]]) {
        return YES;
    }
    return NO;
}

- (id)browser:(NSBrowser *)browser objectValueForItem:(id)item {

    if ([item isMemberOfClass:[ChannelList class]]) {
        return @"ChannelList";
    }

    if ([item isMemberOfClass:[ChannelGroup class]]) {
        return [@" " stringByAppendingString:((ChannelGroup *) item).name];
    }

    if ([item isMemberOfClass:[Channel class]]) {
        Channel *c = ((Channel *) item);
        return [@" " stringByAppendingString:c.name];
    }

    if ([item isMemberOfClass:[Show class]]) {
        Show *show = (Show *) item;
        return show.displayName;
    }

    return @"unknown";
}

- (void)browser:(NSBrowser *)sender willDisplayCell:(id)cell atRow:(NSInteger)row column:(NSInteger)column {

    if (column == 2) {

        NSDictionary *stringAttribute = @{NSForegroundColorAttributeName : [NSColor textColor]};
        NSNumber *currentTimestamp = [Utils currentUnixTimestamp];

        NSIndexPath *indexPath = [self.epgBrowser indexPathForColumn:2];
        Channel *parentChannel = [self.epgBrowser itemAtIndexPath:indexPath];

        NSIndexPath *indexPathAtCell = [indexPath indexPathByAddingIndex:row];
        Show *showAtCell = [self.epgBrowser itemAtIndexPath:indexPathAtCell];


        NSColor *alreadyPlayedColor = [NSColor colorWithSRGBRed:0 green:0 blue:0 alpha:0.7];

        if (showAtCell.end < currentTimestamp) {

            stringAttribute = @{NSForegroundColorAttributeName : alreadyPlayedColor};
        }

        if (showAtCell.start <= currentTimestamp && showAtCell.end > currentTimestamp) {

            stringAttribute = @{
                    NSForegroundColorAttributeName : [NSColor textColor],
                    NSFontAttributeName : [NSFont boldSystemFontOfSize:[NSFont systemFontSize]]
            };
        }


        NSAttributedString *prefix;
        if (parentChannel.hasArchive) {
            if (showAtCell.isInArchiveRange) {
                prefix = [[NSAttributedString alloc] initWithString:@" ● "
                                                         attributes:@{NSForegroundColorAttributeName : [NSColor redColor]}];
            } else if (showAtCell.isMoreThan2WeeksOld) {
                prefix = [[NSAttributedString alloc] initWithString:@" ● "
                                                         attributes:@{NSForegroundColorAttributeName : alreadyPlayedColor}];
            } else {
                prefix = [[NSAttributedString alloc] initWithString:@"    "
                                                         attributes:@{NSForegroundColorAttributeName : [NSColor textColor]}];
            }

        } else {
            prefix = [[NSAttributedString alloc] initWithString:@"   "
                                                     attributes:@{NSForegroundColorAttributeName : [NSColor textColor]}];
        }

        NSMutableAttributedString *value = [[NSMutableAttributedString alloc] initWithString:@""];
        [value appendAttributedString:prefix];
        [value appendAttributedString:[[NSAttributedString alloc] initWithString:[cell stringValue] attributes:stringAttribute]];
        [cell setAttributedStringValue:value];


    } else {

        NSDictionary *stringAttribute = @{NSForegroundColorAttributeName : [NSColor textColor]};
        NSAttributedString *value = [[NSAttributedString alloc] initWithString:[cell stringValue] attributes:stringAttribute];
        [cell setAttributedStringValue:value];

    }

}

//- (CGFloat)browser:(NSBrowser *)browser sizeToFitWidthOfColumn:(NSInteger)columnIndex {
//    if (columnIndex == 2)
//        return 380;
//
//    if (columnIndex == 3)
//        return 880;
//
//    return -1;
//}

- (NSViewController *)browser:(NSBrowser *)browser previewViewControllerForLeafItem:(id)item {
    if (_sharedShowPreviewController == nil) {
        _sharedShowPreviewController = [[NSViewController alloc] initWithNibName:@"ShowPreview" bundle:[NSBundle bundleForClass:[self class]]];

        NSButton *startPlaybackButton = [[_sharedShowPreviewController view] viewWithTag:100];
        [startPlaybackButton setTarget:self];
        [startPlaybackButton setAction:@selector(_browserDblClicked:)];

    }

    NSIndexPath *indexPath = [self.epgBrowser indexPathForColumn:2];
    Channel *parentChannel = [self.epgBrowser itemAtIndexPath:indexPath];

    NSTextField *channelName = [[_sharedShowPreviewController view] viewWithTag:101];
    [channelName setStringValue:parentChannel.name];

    return _sharedShowPreviewController; // NSBrowser will set the representedObject for us

}


@end
