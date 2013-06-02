//
//  EPGVideothekViewController.m
//  KartinaX.TV
//
//  Created by mk on 30.05.13.
//  Copyright (c) 2013 Maxim Kalina. All rights reserved.
//

#import "EPGVideothekViewController.h"
#import "KartinaClient.h"
#import "KartinaSession.h"
#import "VODList.h"
#import "VODItem.h"
#import "VODItemDetails.h"
#import "PlaybackItem.h"

@interface EPGVideothekViewController ()

@end

@implementation EPGVideothekViewController {

    VODList *_vodList;
    VODItemDetails *_vodItemDetails;


}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }

    return self;
}


- (void)loadView {
    [super loadView];

    AGScopeBarGroup *group = nil;
    AGScopeBarItem *item = nil;
    group = [_scopeBar addGroupWithIdentifier:@"1" label:nil items:nil];
    [group addItemWithIdentifier:@"best" title:NSLocalizedString(@"Best", @"Best") ];
    [group addItemWithIdentifier:@"last" title:NSLocalizedString(@"Last", @"Last") ];
    group.selectionMode = AGScopeBarGroupSelectOne;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(vodListLoaded:)
                                                 name:kVODListLoadSuccessfulNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(vodListNotLoaded:)
                                                 name:kVODListLoadFailedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(vodItemDetailsLoaded:)
                                                 name:kVODItemDetailsLoadSuccessfulNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(vodItemDetailsNotLoaded:)
                                                 name:kVODItemDetailsLoadFailedNotification
                                               object:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)vodListLoaded:(NSNotification *)notification {
    [self.parentController stopLoadingIndicator];
    _vodList = [notification.userInfo objectForKey:@"vodList"];
    [self.vodTableView reloadData];
}

- (void)vodListNotLoaded:(NSNotification *)notification {
    [self.parentController stopLoadingIndicator];
}


- (void)vodItemDetailsLoaded:(NSNotification *)notification {
    [self.parentController stopLoadingIndicator];

    _vodItemDetails = [notification.userInfo objectForKey:@"vodItemDetails"];
    [self.vodDetailsTitle setStringValue:_vodItemDetails.name];
    [self.vodDetailsImage setImage:_vodItemDetails.posterImage];
    [self.vodDetailsYear setStringValue:_vodItemDetails.year];
    [self.vodDetailsCountry setStringValue:_vodItemDetails.country];
    [self.vodDetailsImdb setStringValue:_vodItemDetails.ratingImdb];
    [self.vodDetailsKinopoisk setStringValue:_vodItemDetails.ratingKinopoisk];
    [self.vodDetailsMpaa setStringValue:_vodItemDetails.ratingMpaa];
    [self.vodDetailsGenres setStringValue:_vodItemDetails.genres];
    [self.vodDetailsDescription setStringValue:_vodItemDetails.description];
    [self.vodDetailsView setHidden:NO];


//    NSLog(@"director: %@", item.director);
//    NSLog(@"scenario: %@", item.scenario);
//    NSLog(@"actors: %@", item.actors);
}

- (void)vodItemDetailsNotLoaded:(NSNotification *)notification {
    [self.parentController stopLoadingIndicator];
}


- (void)scopeBar:(AGScopeBar *)theScopeBar item:(AGScopeBarItem *)item wasSelected:(BOOL)selected; {

    [self.parentController startLoadingIndicator];
    KartinaClient *client = [KartinaClient sharedInstance];
    [client loadVODList:item.identifier page:@1 query:nil genre:nil itemsPerPage:@20];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_vodList != nil ) {
        return _vodList.items.count;
    }
    return 0;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    if (_vodList == nil || _vodList.items == nil) {
        return nil;
    }

    VODItem *item = _vodList.items[(NSUInteger) row];
    NSString *identifier = tableColumn.identifier;
    if ([identifier isEqualToString:@"VODColumn"]) {
        NSTableCellView *cellView = [tableView makeViewWithIdentifier:@"VODCell" owner:self];
        [cellView.textField setStringValue:item.name];
        [cellView.imageView setImage:item.posterImage];

        [[cellView viewWithTag:100] setStringValue:item.year];
        [[cellView viewWithTag:101] setStringValue:item.country];


        return cellView;
    }

    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {

    VODItem *item = _vodList.items[(NSUInteger) self.vodTableView.selectedRow];

    [self.parentController startLoadingIndicator];
    [[KartinaClient sharedInstance] loadVODItemDetails:item.id];

}


- (IBAction)playVODRequested:(id)sender {

    NSArray *videos = _vodItemDetails.videosDictionary;

    // @todo handle multiple videos...

    PlaybackItem *playbackItem = [[PlaybackItem alloc] initWithName:_vodItemDetails.name vodId:videos[0][@"id"]];
    if (playbackItem != nil) {
        [[NSNotificationCenter defaultCenter]
                postNotificationName:kPlaybackItemSelectedNotification
                              object:self
                            userInfo:@{@"playbackItem" : playbackItem}
        ];
    }

}
@end
