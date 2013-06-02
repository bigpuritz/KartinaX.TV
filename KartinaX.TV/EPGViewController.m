//
//  EPGViewController.m
//  KartinaX.TV
//
//  Created by mk on 10.03.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "EPGViewController.h"
#import "KartinaClient.h"
#import "ChannelList.h"
#import "ChannelGroup.h"
#import "Show.h"
#import "KartinaSession.h"
#import "EPGData.h"
#import "Utils.h"

@interface EPGViewController ()

@property(strong) NSTimer *timer;

@end


@implementation EPGViewController {

}

- (id)init {
    self = [super initWithWindowNibName:@"EPGViewController"];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(epgLoaded:)
                                                     name:kEPGLoadSuccessfulNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)windowDidLoad {

    [self.datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"]];
    self.datePicker.dateValue = [NSDate date];
    [self.datePickerCell sendActionOn:NSLeftMouseDown];



    //[self.epgBrowser setPath:@"/ Германия/ Das Erste/   20:15 Alles für meine Tochter"];
    //NSIndexPath *path = [NSIndexPath indexPathWithIndex:10];
    //path = [[path indexPathByAddingIndex:0] indexPathByAddingIndex:27];
    //[self.epgBrowser setSelectionIndexPath:path];

}


- (void)awakeFromNib {
    // This is how we make the NSBrowser transparent

    [super awakeFromNib];
    [self.epgBrowser setBackgroundColor:[NSColor clearColor]];
    [self.epgBrowser setAction:@selector(_browserClicked:)];
    [self.epgBrowser setDoubleAction:@selector(_browserDblClicked:)];
    [self.epgBrowser setTarget:self];

    NSLog(@"enclosing: %@", self.epgBrowser.enclosingScrollView);

    [self.epgBrowser setAutohidesScroller:YES];
    [self.epgBrowser.enclosingScrollView setScrollerStyle:NSScrollerStyleOverlay];

    NSArray *subviews = self.epgBrowser.subviews;

    NSView *v = subviews[0];
    NSScroller *scroller = v.subviews[1];
    [scroller setScrollerStyle:NSScrollerStyleOverlay];


    [self.window setDelegate:self];
    [self startTimer];
}

- (void)startTimer {

    if (self.timer != nil)
        [self stopTimer];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerFired)
                                                userInfo:nil repeats:YES];
}


- (void)stopTimer {
    [self.timer invalidate];
}

- (void)timerFired {

    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dayFormatter setDateFormat:@"dd.MM.yyyy"];

    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [timeFormatter setDateFormat:@"HH:mm:ss"];

    self.currentDay.stringValue = [dayFormatter stringFromDate:[NSDate date]];
    self.currentTime.stringValue = [timeFormatter stringFromDate:[NSDate date]];

}


- (void)_browserClicked:(id)sender {

    NSLog(@"path: %@", self.epgBrowser.path);
    NSLog(@"path: %@", self.epgBrowser.selectionIndexPath);

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
        NSDictionary *stringAttribute = @{NSForegroundColorAttributeName : [NSColor whiteColor]};
        NSNumber *currentTimestamp = [Utils currentUnixTimestamp];

        NSIndexPath *indexPath = [self.epgBrowser indexPathForColumn:2];
        Channel *parentChannel = [self.epgBrowser itemAtIndexPath:indexPath];

        NSIndexPath *indexPathAtCell = [indexPath indexPathByAddingIndex:row];
        Show *showAtCell = [self.epgBrowser itemAtIndexPath:indexPathAtCell];

        if (showAtCell.end < currentTimestamp) {
            stringAttribute = @{NSForegroundColorAttributeName : [NSColor grayColor]};
        }

        if (showAtCell.start <= currentTimestamp && showAtCell.end > currentTimestamp) {

            stringAttribute = @{
                    NSForegroundColorAttributeName : [NSColor whiteColor],
                    NSFontAttributeName : [NSFont boldSystemFontOfSize:[NSFont systemFontSize]]
            };
        }


        NSMutableAttributedString *value = [[NSMutableAttributedString alloc] initWithString:@""];

        if (parentChannel.hasArchive) {

            if (showAtCell.isInArchiveRange) {
                [value appendAttributedString:[[NSAttributedString alloc] initWithString:@" ● "
                                                                              attributes:@{NSForegroundColorAttributeName : [NSColor redColor]}]];

            } else if (showAtCell.isMoreThan2WeeksOld) {

                [value appendAttributedString:[[NSAttributedString alloc] initWithString:@" ● "
                                                                              attributes:@{NSForegroundColorAttributeName : [NSColor grayColor]}]];
            } else {

                [value appendAttributedString:[[NSAttributedString alloc] initWithString:@"    "
                                                                              attributes:@{NSForegroundColorAttributeName : [NSColor whiteColor]}]];
            }

        } else {

            [value appendAttributedString:[[NSAttributedString alloc] initWithString:@"   "
                                                                          attributes:@{NSForegroundColorAttributeName : [NSColor whiteColor]}]];


        }


        [value appendAttributedString:[[NSAttributedString alloc] initWithString:[cell stringValue] attributes:stringAttribute]];
        [cell setAttributedStringValue:value];


    } else {

        NSDictionary *stringAttribute = @{NSForegroundColorAttributeName : [NSColor whiteColor]};
        NSAttributedString *value = [[NSAttributedString alloc] initWithString:[cell stringValue] attributes:stringAttribute];
        [cell setAttributedStringValue:value];

    }

    // We are drawing into a transparent browser on a HUD window. Make the cell draw the text white.

}


- (IBAction)epgDateSelected:(id)sender {
    [self.loadingIndicator startAnimation:self];
    [self.loadingIndicator setHidden:NO];
    [self.datePicker setEnabled:NO];
    KartinaClient *client = [KartinaClient sharedInstance];
    [client loadEPG:self.datePicker.dateValue];

}

- (void)epgLoaded:(NSNotification *)notification {
    [self.loadingIndicator stopAnimation:self];
    [self.loadingIndicator setHidden:YES];
    [self.datePicker setEnabled:YES];
    [self.epgBrowser reloadColumn:2];
}


- (void)show {
    [self timerFired];
    [self startTimer];
    [self.window orderFront:self];
}


- (void)windowWillClose:(NSNotification *)notification {
    [self stopTimer];
}

@end
