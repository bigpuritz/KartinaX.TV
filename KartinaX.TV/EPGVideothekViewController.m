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
#import "VODGenre.h"

@interface EPGVideothekViewController ()

@end

@implementation EPGVideothekViewController {

    VODList *_lastLoadedVODList;
    NSMutableArray *_vodItems;
    VODItemDetails *_vodItemDetails;
    NSString *_selectedVODType;
    NSString *_selectedVODGenreId;
    AGScopeBarItem *_genresItem;

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

    group = [_scopeBar addGroupWithIdentifier:@"0" label:nil items:nil];
    [group addItemWithIdentifier:@"last" title:NSLocalizedString(@"Last", @"Last") ];
    [group addItemWithIdentifier:@"best" title:NSLocalizedString(@"Best", @"Best") ];
    group.selectionMode = AGScopeBarGroupSelectOne;

    group = [_scopeBar addGroupWithIdentifier:@"1" label:NSLocalizedString(@"FilterGenres", @"FilterGenres") items:nil];
    _genresItem = [group addItemWithIdentifier:@"genres" title:NSLocalizedString(@"All", @"All")];
    NSMenu *_genresMenu = [[NSMenu alloc] init];

    NSArray *genres = [KartinaSession vodGenres];
    // all genres
    NSMenuItem *menuItemAll = [[NSMenuItem alloc] initWithTitle:NSLocalizedString(@"All", @"All") action:@selector(vodGenreSelected:) keyEquivalent:@""];
    [menuItemAll setTag:-1];
    [menuItemAll setTarget:self];
    [_genresMenu addItem:menuItemAll];

    for (VODGenre *g in genres) {
        NSMenuItem *menuItem = [[NSMenuItem alloc] initWithTitle:g.name action:@selector(vodGenreSelected:) keyEquivalent:@""];
        [menuItem setTag:[g.id integerValue]];
        [menuItem setTarget:self];
        [_genresMenu addItem:menuItem];
    }
    [_genresMenu setAutoenablesItems:YES];
    _genresItem.menu = _genresMenu;
    group.selectionMode = AGScopeBarGroupSelectNone;
    group.canBeCollapsed = NO;


    _vodItems = [[NSMutableArray alloc] init];

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


- (IBAction)vodGenreSelected:(id)sender {
    [self clearTableView];
    [self.parentController startLoadingIndicator];
    KartinaClient *client = [KartinaClient sharedInstance];

    NSInteger genreId = ((NSMenuItem *) sender).tag;
    if (genreId == -1)
        _selectedVODGenreId = nil;
    else
        _selectedVODGenreId = [NSString stringWithFormat:@"%li", genreId];
    [client loadVODList:_selectedVODType page:@1 query:nil genre:_selectedVODGenreId itemsPerPage:@20];

    _genresItem.title = ((NSMenuItem *) sender).title;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)vodListLoaded:(NSNotification *)notification {
    [self.parentController stopLoadingIndicator];
    VODList *list = [notification.userInfo objectForKey:@"vodList"];
    [_vodItems addObjectsFromArray:list.items];
    _lastLoadedVODList = list;
    [self.vodTableView reloadData];
}

- (void)clearTableView {
    [self.vodTableView scrollRowToVisible:0];
    [self.vodDetailsView setHidden:YES];
    [_vodItems removeAllObjects];
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
    [self.vodDetailsGenres setStringValue:_vodItemDetails.genres];
    [self.vodDetailsDescription setStringValue:_vodItemDetails.description];
    [self.vodDetailsDirector setStringValue:_vodItemDetails.director];
    [self.vodDetailsScenario setStringValue:_vodItemDetails.scenario];
    [self.vodDetailsActors setStringValue:_vodItemDetails.actors];
    [self.vodDetailsView setHidden:NO];
}

- (void)vodItemDetailsNotLoaded:(NSNotification *)notification {
    [self.parentController stopLoadingIndicator];
}


- (void)scopeBar:(AGScopeBar *)theScopeBar item:(AGScopeBarItem *)item wasSelected:(BOOL)selected; {
    _selectedVODType = item.identifier;
    [self clearTableView];
    [self.parentController startLoadingIndicator];
    KartinaClient *client = [KartinaClient sharedInstance];
    [client loadVODList:item.identifier page:@1 query:nil genre:_selectedVODGenreId itemsPerPage:@20];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    NSUInteger numberOfItems = _vodItems.count;
    if (_lastLoadedVODList.total.intValue > numberOfItems) {
        return numberOfItems + 1;
    }
    return numberOfItems;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {

    if (_vodItems == nil || row > _vodItems.count) {
        return nil;
    }

    NSString *identifier = tableColumn.identifier;
    if ([identifier isEqualToString:@"VODColumn"]) {

        NSTableCellView *cellView;
        if (row == _vodItems.count) {
            cellView = [tableView makeViewWithIdentifier:@"LoadMore" owner:self];
            NSString *title = [NSString stringWithFormat:@"Осталось %i. Загрузить еще 20...", (_lastLoadedVODList.total.intValue - _vodItems.count)];
            [[cellView viewWithTag:110] setTitle:title];
        } else {
            VODItem *item = _vodItems[(NSUInteger) row];
            cellView = [tableView makeViewWithIdentifier:@"VODCell" owner:self];
            [cellView.textField setStringValue:item.name];
            [cellView.imageView setImage:item.posterImage];
            [[cellView viewWithTag:100] setStringValue:item.year];
            [[cellView viewWithTag:101] setStringValue:item.country];
        }

        return cellView;
    }

    return nil;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {

    if (self.vodTableView.selectedRow == _vodItems.count)
        return;

    VODItem *item = _vodItems[(NSUInteger) self.vodTableView.selectedRow];
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

- (IBAction)loadMoreRequested:(id)sender {
    [self.parentController startLoadingIndicator];
    int nextPage = _lastLoadedVODList.page.intValue + 1;
    KartinaClient *client = [KartinaClient sharedInstance];
    [client loadVODList:_selectedVODType page:[NSNumber numberWithInt:nextPage] query:nil genre:_selectedVODGenreId itemsPerPage:@20];
}
@end
