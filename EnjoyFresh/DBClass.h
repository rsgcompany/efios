//
//  DBClass.h
//  EnjoyFresh
//
//  Created by Tesla on 07/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "sqlite3.h"
#import "FMDatabase.h"
#import "ProfileClass.h"
#import "DishClass.h"
#import "RestaurantClass.h"
#import "FavoritesClass.h"
#import "ReviewClass.h"
#import "CardDetails.h"
#import <Foundation/Foundation.h>

@interface DBClass : NSObject
{
    
}

@property (strong, nonatomic)NSArray *docPaths;
@property (strong, nonatomic)NSString *documentsDir;
@property (strong, nonatomic)NSString *dbPath;
@property (strong, nonatomic)FMDatabase *database;
@property (strong, nonatomic)NSString *KeyName;
@property (strong, nonatomic)NSString *KeyValue;
@property (strong, nonatomic)NSString *ExecuteString;
@property (strong, nonatomic)NSString *ExecuteSubString;

@property (strong, nonatomic)ProfileClass *UserProfileClass;
@property (strong, nonatomic)DishClass *DishDetailsClass;
@property (strong, nonatomic)RestaurantClass *RestaurantDetailsClass;
@property (strong, nonatomic)FavoritesClass *FavoritesClassObj;
@property (strong, nonatomic)ReviewClass *DishReviewClass;
@property (strong, nonatomic)CardDetails *CardDetailsClass;



- (void) CreateDB;
- (void) DropUserProfileTable;
- (void) DropRestaurantDetailsTable;

- (void) ClearUserProfileDetails;
- (void) InserUserProfileDetails : (ProfileClass *) CurrentUserDetails;
- (void) UpdateUserProfileDetails : (ProfileClass *) CurrentUserDetails;
- (ProfileClass *) GetUserProfileDetails;

- (void) InserRestaurantDetails : (RestaurantClass *) RestaurantDetails;
- (RestaurantClass *) GetRestaurantDetailsForID : (NSString *) restaurant_id;

- (void) DropUserFavoritesTable;
- (void) ClearUserFavoritesTable;
- (void) AddUserFavorite : (FavoritesClass *) CurrentFavoriteClass;
- (void) UpdateRestaurantFavorite : (NSString *) restaurant_id : (NSString *) restaurant_is_favorite;
- (NSString *) GetFavoriteStatusForRestaurant : (NSString *) restaurant_id;
- (NSMutableArray *) GetAllUserFavorites;
@property (nonatomic) BOOL RestaurantIsFavorite;

- (void) DropCardDetailsTable;
- (void) ClearCardDetails;
- (void) InsertCardDetails : (CardDetails *) CurrentCardDetails;
- (CardDetails *) GetCardDetailsForNumber : (NSString *) card_number;
- (void) DeleteCardDetails : (NSString *) card_number;
- (BOOL) CheckIfCardsExists : (NSString *) card_number;
- (NSMutableArray *) GetAllUserCards;

@end
