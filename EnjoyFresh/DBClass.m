//
//  DBClass.m
//  EnjoyFresh
//
//  Created by Tesla on 07/10/14.
//  Copyright (c) 2014 Murali. All rights reserved.
//

#import "DBClass.h"

@implementation DBClass
@synthesize docPaths;
@synthesize documentsDir;
@synthesize dbPath;
@synthesize database;
@synthesize KeyName;
@synthesize KeyValue;
@synthesize ExecuteString;

- (void) CreateDB;
{
    RestaurantIsFavorite = NO;
    
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"EnjoyFresh.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    //PROFILE TABLE
    [database executeUpdate:
     @"CREATE TABLE ProfileTable (user_id TEXT DEFAULT NULL,  user_devicetoken TEXT DEFAULT NULL, user_email TEXT DEFAULT NULL, user_first_name TEXT DEFAULT NULL, user_image TEXT DEFAULT NULL, user_is_discount_applied TEXT DEFAULT NULL, user_is_sweep TEXT DEFAULT NULL, user_last_name TEXT DEFAULT NULL,  user_mobile TEXT DEFAULT NULL, user_ref_promo TEXT DEFAULT NULL, user_ref_promo_count TEXT DEFAULT NULL, user_zipcode TEXT DEFAULT NULL, user_fb TEXT DEFAULT NULL, user_twitter TEXT DEFAULT NULL, user_password TEXT DEFAULT NULL, user_auth_id TEXT DEFAULT NULL)"];
    
    [database close];
    
    
    //RESTAURANTS TABLE
    [database open];
    
    [database executeUpdate:
     @"CREATE TABLE RestaurantDetails (restaurant_id TEXT DEFAULT NULL, restaurant_address TEXT DEFAULT NULL, restaurant_city TEXT DEFAULT NULL, restaurant_city_tax TEXT DEFAULT NULL, restaurant_description TEXT DEFAULT NULL, restaurant_lat TEXT DEFAULT NULL, restaurant_lon TEXT DEFAULT NULL, restaurant_owner_name TEXT DEFAULT NULL, restaurant_phone TEXT DEFAULT NULL, restaurant_state TEXT DEFAULT NULL, restaurant_state_tax TEXT DEFAULT NULL, restaurant_title TEXT DEFAULT NULL, restaurant_zip TEXT DEFAULT NULL, restaurant_is_favorite TEXT DEFAULT NULL, user_id TEXT DEFAULT NULL)"];
    
    [database close];
    
    
    //USER FAVORITES
    [database open];
    
    [database executeUpdate:
     @"CREATE TABLE UserFavorites (restaurant_id TEXT DEFAULT NULL, restaurant_city TEXT DEFAULT NULL, restaurant_title TEXT DEFAULT NULL, restaurant_is_favorite TEXT DEFAULT NULL, restaurant_image_thumbnail  TEXT DEFAULT NULL)"];
    
    [database close];
    
    //CARD DETAILS
    [database open];
    
    [database executeUpdate:
     @"CREATE TABLE CardDetails (card_type TEXT DEFAULT NULL, card_name TEXT DEFAULT NULL, card_number TEXT DEFAULT NULL, card_month TEXT DEFAULT NULL, card_year TEXT DEFAULT NULL, card_cvv TEXT DEFAULT NULL, card_address TEXT DEFAULT NULL, card_city TEXT DEFAULT NULL, card_state TEXT DEFAULT NULL, card_zip TEXT DEFAULT NULL, card_display TEXT DEFAULT NULL)"];
    
    [database close];
    
    
}

- (void) SetUpDB
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"EnjoyFresh.sqlite"];
    database = [FMDatabase databaseWithPath:dbPath];
}

- (void) DropUserProfileTable;
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"EnjoyFresh.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:
     @"DROP TABLE IF EXISTS ProfileTable"];
    
    [database close];

}

- (void) DropRestaurantDetailsTable;
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"EnjoyFresh.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:
     @"DROP TABLE IF EXISTS RestaurantDetails"];
    
    [database close];    
}

- (void) DropUserFavoritesTable;
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"EnjoyFresh.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:
     @"DROP TABLE IF EXISTS UserFavorites"];
    
    [database close];
}

- (void) DropCardDetailsTable;
{
    docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDir = [docPaths objectAtIndex:0];
    dbPath = [documentsDir   stringByAppendingPathComponent:@"EnjoyFresh.sqlite"];
    
    database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    [database executeUpdate:
     @"DROP TABLE IF EXISTS CardDetails"];
    
    [database close];
}



- (void) ClearUserFavoritesTable;
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs = [database executeQuery:@"DELETE FROM UserFavorites", nil];
    
    
    while ([rs next])
    {
        
    }
    
    [rs close];
    
    [database close];
}

- (void) ClearUserProfileDetails;
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs = [database executeQuery:@"DELETE FROM ProfileTable", nil];
    
    
    while ([rs next])
    {
        
    }
    
    [rs close];
    
    [database close];
}

- (void) UpdateUserProfileDetails : (ProfileClass *) CurrentUserDetails;
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"FB ID"
//                                                    message: CurrentUserDetails.user_fb
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    
    //[alert show];
    
    [self ClearUserProfileDetails];
    [self InserUserProfileDetails : CurrentUserDetails];
}

- (void) InserUserProfileDetails : (ProfileClass *) CurrentUserDetails;
{
    [self ClearUserProfileDetails];
    
    [self SetUpDB];
    
    ExecuteString = @"";
    ExecuteString =
    [ExecuteString stringByAppendingString:@"INSERT INTO ProfileTable (user_id, user_devicetoken, user_email, user_first_name, user_image, user_is_discount_applied, user_is_sweep, user_last_name, user_mobile, user_ref_promo, user_ref_promo_count, user_ref_promo_count, user_fb, user_twitter, user_password, user_auth_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
   // NSLog(@"User FB: %@", CurrentUserDetails.user_fb);
    
    
    
    
    [database open];
    [database executeUpdate: ExecuteString,
     CurrentUserDetails.user_id,
     CurrentUserDetails.user_devicetoken,
     CurrentUserDetails.user_email,
     CurrentUserDetails.user_first_name,
     CurrentUserDetails.user_image,
     CurrentUserDetails.user_is_discount_applied,
     CurrentUserDetails.user_is_sweep,
     CurrentUserDetails.user_last_name,
     CurrentUserDetails.user_mobile,
     CurrentUserDetails.user_ref_promo,
     CurrentUserDetails.user_ref_promo_count,
     CurrentUserDetails.user_zipcode,
     CurrentUserDetails.user_fb,
     CurrentUserDetails.user_twitter,
     CurrentUserDetails.user_password,
     CurrentUserDetails.user_auth_id,
     nil];
    
    [database close];
    
    
}

@synthesize RestaurantIsFavorite;
- (void) AddUserFavorite : (FavoritesClass *) CurrentFavoriteClass;
{
    if([self CheckIfRestaurantFavoriteRowExists : CurrentFavoriteClass.restaurant_id])
    {
        return;
    }
    
    [self SetUpDB];
    
    ExecuteString = @"";
    ExecuteString =
    [ExecuteString stringByAppendingString:@"INSERT INTO UserFavorites (restaurant_id, restaurant_city, restaurant_title, restaurant_is_favorite, restaurant_image_thumbnail) VALUES (?, ?, ?, ?, ?)"];
    
    [database open];
    [database executeUpdate: ExecuteString,
     CurrentFavoriteClass.restaurant_id,
     CurrentFavoriteClass.restaurant_city,
     CurrentFavoriteClass.restaurant_title,
     CurrentFavoriteClass.restaurant_is_favorite,
     CurrentFavoriteClass.restaurant_image_thumbnail,
     nil];
    
    [database close];
}

- (BOOL) CheckIfRestaurantFavoriteRowExists : (NSString *) restaurant_id
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs =
    [database executeQuery:@"SELECT * FROM UserFavorites WHERE restaurant_id = ?", restaurant_id, nil];
    while ([rs next])
    {
        [rs close];
        
        [database close];
        
        return YES;
    }
    
    return NO;
}

@synthesize FavoritesClassObj;
- (void) UpdateRestaurantFavorite : (NSString *) restaurant_id : (NSString *) restaurant_is_favorite;
{
    if(![self CheckIfRestaurantFavoriteRowExists : restaurant_id])
    {
        [self AddUserFavorite: FavoritesClassObj];
    }
    
    [self SetUpDB];
    
    ExecuteString = @"";
    ExecuteString = [ExecuteString stringByAppendingString:@"UPDATE UserFavorites SET "];
    ExecuteString = [ExecuteString stringByAppendingString:@"restaurant_is_favorite"];
    ExecuteString = [ExecuteString stringByAppendingString:@"= ? "];
    ExecuteString = [ExecuteString stringByAppendingString:@"WHERE restaurant_id = ?"];
    
    [database open];
    [database executeUpdate: ExecuteString,
     [NSString stringWithFormat:@"%@", restaurant_is_favorite],
     [NSString stringWithFormat:@"%@", restaurant_id], nil];
    
    [database close];
    
    id favs = [self GetAllUserFavorites];
    
    NSLog(@"Favs: %@", favs);
}

- (NSMutableArray *) GetAllUserFavorites;
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs =
    [database executeQuery:@"SELECT * FROM UserFavorites WHERE restaurant_is_favorite = 'Y' ", nil];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    while ([rs next])
    {
        FavoritesClassObj = [[FavoritesClass alloc] init];
        FavoritesClassObj.restaurant_id = [rs stringForColumn:@"restaurant_id"];
        FavoritesClassObj.restaurant_city = [rs stringForColumn:@"restaurant_city"];
        FavoritesClassObj.restaurant_title = [rs stringForColumn:@"restaurant_title"];
        FavoritesClassObj.restaurant_is_favorite = [rs stringForColumn:@"restaurant_is_favorite"];
        FavoritesClassObj.restaurant_image_thumbnail = [rs stringForColumn:@"restaurant_image_thumbnail"];
        
        [returnArray addObject:FavoritesClassObj];
    }
    
    [rs close];
    
    [database close];
    
    return returnArray;
}

- (NSString *) GetFavoriteStatusForRestaurant : (NSString *) restaurant_id;
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs =
    [database executeQuery:@"SELECT * FROM UserFavorites WHERE restaurant_id = ?", restaurant_id, nil];
    
    while ([rs next])
    {
        NSString *retString = [rs stringForColumn:@"restaurant_is_favorite"];
        [rs close];
        
        [database close];
        
        return retString;
    }
    
    return @"";
}

@synthesize UserProfileClass;
- (ProfileClass *) GetUserProfileDetails;
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs = [database executeQuery:@"SELECT * FROM ProfileTable", nil];
    
    while ([rs next])
    {
        UserProfileClass = [[ProfileClass alloc] init];
        UserProfileClass.user_id = [rs stringForColumn:@"user_id"];
        UserProfileClass.user_devicetoken = [rs stringForColumn:@"user_devicetoken"];
        UserProfileClass.user_email = [rs stringForColumn:@"user_email"];
        UserProfileClass.user_first_name = [rs stringForColumn:@"user_first_name"];
        UserProfileClass.user_image = [rs stringForColumn:@"user_image"];
        UserProfileClass.user_is_discount_applied = [rs stringForColumn:@"user_is_discount_applied"];
        UserProfileClass.user_is_sweep = [rs stringForColumn:@"user_is_sweep"];
        UserProfileClass.user_last_name = [rs stringForColumn:@"user_last_name"];
        UserProfileClass.user_mobile = [rs stringForColumn:@"user_mobile"];
        UserProfileClass.user_ref_promo = [rs stringForColumn:@"user_ref_promo"];
        UserProfileClass.user_ref_promo_count = [rs stringForColumn:@"user_ref_promo_count"];
        UserProfileClass.user_zipcode = [rs stringForColumn:@"user_zipcode"];
        UserProfileClass.user_fb = [rs stringForColumn:@"user_fb"];
        UserProfileClass.user_twitter = [rs stringForColumn:@"user_twitter"];
        UserProfileClass.user_password = [rs stringForColumn:@"user_password"];
        UserProfileClass.user_auth_id = [rs stringForColumn:@"user_auth_id"];
        
        
        [rs close];
        
        [database close];
      
        return UserProfileClass;
    }
    
    [rs close];
    
    [database close];
    
    return nil;
}

- (void) InserRestaurantDetails : (RestaurantClass *) RestaurantDetails;
{
    [self SetUpDB];
    
    ExecuteString = @"";
    ExecuteString =
    [ExecuteString stringByAppendingString:@"INSERT INTO RestaurantDetails (restaurant_id, restaurant_address, restaurant_city, restaurant_city_tax, restaurant_description, restaurant_lat, restaurant_lon, restaurant_owner_name, restaurant_phone, restaurant_state, restaurant_state_tax, restaurant_title, restaurant_zip, restaurant_images, restaurant_is_favorite, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
    [database open];
    [database executeUpdate: ExecuteString,
     RestaurantDetails.restaurant_id,
     RestaurantDetails.restaurant_address,
     RestaurantDetails.restaurant_city,
     RestaurantDetails.restaurant_city_tax,
     RestaurantDetails.restaurant_description,
     RestaurantDetails.restaurant_lat,
     RestaurantDetails.restaurant_lon,
     RestaurantDetails.restaurant_owner_name,
     RestaurantDetails.restaurant_phone,
     RestaurantDetails.restaurant_state,
     RestaurantDetails.restaurant_state_tax,
     RestaurantDetails.restaurant_title,
     RestaurantDetails.restaurant_zip,
     RestaurantDetails.restaurant_images,
     RestaurantDetails.restaurant_is_favorite,
     RestaurantDetails.user_id,
     nil];
    
    [database close];

}

@synthesize RestaurantDetailsClass;
- (RestaurantClass *) GetRestaurantDetailsForID : (NSString *) restaurant_id;
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs = [database executeQuery:@"SELECT * FROM RestaurantDetails WHERE restaurant_id = ?", restaurant_id, nil];
    
    while ([rs next])
    {
        RestaurantDetailsClass = [[RestaurantClass alloc] init];
        RestaurantDetailsClass.restaurant_id = [rs stringForColumn:@"restaurant_id"];
        RestaurantDetailsClass.restaurant_address = [rs stringForColumn:@"restaurant_address"];
        RestaurantDetailsClass.restaurant_city = [rs stringForColumn:@"restaurant_city"];
        RestaurantDetailsClass.restaurant_city_tax = [rs stringForColumn:@"restaurant_city_tax"];
        RestaurantDetailsClass.restaurant_description = [rs stringForColumn:@"restaurant_description"];
        RestaurantDetailsClass.restaurant_lat = [rs stringForColumn:@"restaurant_lat"];
        RestaurantDetailsClass.restaurant_lon = [rs stringForColumn:@"restaurant_lon"];
        RestaurantDetailsClass.restaurant_owner_name = [rs stringForColumn:@"restaurant_owner_name"];
        RestaurantDetailsClass.restaurant_phone = [rs stringForColumn:@"restaurant_phone"];
        RestaurantDetailsClass.restaurant_state = [rs stringForColumn:@"restaurant_state"];
        RestaurantDetailsClass.restaurant_state_tax = [rs stringForColumn:@"restaurant_state_tax"];
        RestaurantDetailsClass.restaurant_title = [rs stringForColumn:@"restaurant_title"];
        RestaurantDetailsClass.restaurant_zip = [rs stringForColumn:@"restaurant_zip"];
        RestaurantDetailsClass.restaurant_is_favorite = [rs stringForColumn:@"restaurant_is_favorite"];
        RestaurantDetailsClass.user_id = [rs stringForColumn:@"user_id"];
        
        [rs close];
        
        [database close];
        
        return RestaurantDetailsClass;
    }
    
    [rs close];
    
    [database close];
    
    return nil;
}


- (void) InsertCardDetails : (CardDetails *) CurrentCardDetails;
{
    [self SetUpDB];
    
    ExecuteString = @"";
    ExecuteString =
    [ExecuteString stringByAppendingString:@"INSERT INTO CardDetails (card_type, card_name, card_number, card_month, card_year, card_cvv, card_address, card_city, card_state, card_zip, card_display) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"];
    
    [database open];
    [database executeUpdate: ExecuteString,
     CurrentCardDetails.card_type,
     CurrentCardDetails.card_name,
     CurrentCardDetails.card_number,
     CurrentCardDetails.card_month,
     CurrentCardDetails.card_year,
     CurrentCardDetails.card_cvv,
     CurrentCardDetails.card_address,
     CurrentCardDetails.card_city,
     CurrentCardDetails.card_state,
     CurrentCardDetails.card_zip,
     CurrentCardDetails.card_display,
     nil];
    
    [database close];
}

@synthesize CardDetailsClass;
- (CardDetails *) GetCardDetailsForNumber : (NSString *) card_number;
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs = [database executeQuery:@"SELECT * FROM CardDetails WHERE card_number = ?", card_number, nil];
    
    while ([rs next])
    {
        CardDetailsClass = [[CardDetails alloc] init];
        CardDetailsClass.card_type = [rs stringForColumn:@"card_type"];
        CardDetailsClass.card_name = [rs stringForColumn:@"card_name"];
        CardDetailsClass.card_number = [rs stringForColumn:@"card_number"];
        CardDetailsClass.card_month = [rs stringForColumn:@"card_month"];
        CardDetailsClass.card_year = [rs stringForColumn:@"card_year"];
        CardDetailsClass.card_cvv = [rs stringForColumn:@"card_cvv"];
        CardDetailsClass.card_address = [rs stringForColumn:@"card_address"];
        CardDetailsClass.card_city = [rs stringForColumn:@"card_city"];
        CardDetailsClass.card_state = [rs stringForColumn:@"card_state"];
        CardDetailsClass.card_zip = [rs stringForColumn:@"card_zip"];
        CardDetailsClass.card_display = [rs stringForColumn:@"card_display"];
        
        [rs close];
        
        [database close];
        
        return CardDetailsClass;
    }
    
    [rs close];
    
    [database close];
    
    return nil;
}

- (NSMutableArray *) GetAllUserCards;
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs =
    [database executeQuery:@"SELECT * FROM CardDetails", nil];
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    while ([rs next])
    {
        CardDetailsClass = [[CardDetails alloc] init];
        CardDetailsClass.card_type = [rs stringForColumn:@"card_type"];
        CardDetailsClass.card_name = [rs stringForColumn:@"card_name"];
        CardDetailsClass.card_number = [rs stringForColumn:@"card_number"];
        CardDetailsClass.card_month = [rs stringForColumn:@"card_month"];
        CardDetailsClass.card_year = [rs stringForColumn:@"card_year"];
        CardDetailsClass.card_cvv = [rs stringForColumn:@"card_cvv"];
        CardDetailsClass.card_address = [rs stringForColumn:@"card_address"];
        CardDetailsClass.card_city = [rs stringForColumn:@"card_city"];
        CardDetailsClass.card_state = [rs stringForColumn:@"card_state"];
        CardDetailsClass.card_zip = [rs stringForColumn:@"card_zip"];
        CardDetailsClass.card_display = [rs stringForColumn:@"card_display"];
        
        [returnArray addObject:CardDetailsClass];
    }
    
    [rs close];
    
    [database close];
    
    return returnArray;
}

- (void) DeleteCardDetails : (NSString *) card_number;
{
    if(![self CheckIfCardsExists : card_number])
    {
        return;
    }
    
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs = [database executeQuery:@"DELETE FROM CardDetails where card_number = ?", card_number, nil];
    
    
    while ([rs next])
    {
        
    }
    
    [rs close];
    
    [database close];
}

- (void) ClearCardDetails;
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs = [database executeQuery:@"DELETE FROM CardDetails", nil];
    
    
    while ([rs next])
    {
        
    }
    
    [rs close];
    
    [database close];
}

- (BOOL) CheckIfCardsExists : (NSString *) card_number;
{
    [self SetUpDB];
    
    [database open];
    
    FMResultSet *rs = [database executeQuery:@"Select * FROM CardDetails where card_number = ?", card_number, nil];
    
    
    while ([rs next])
    {
        [rs close];
        
        [database close];
        
        return  YES;
    }
    
    [rs close];
    
    [database close];
    
    return  NO;
}


@end
