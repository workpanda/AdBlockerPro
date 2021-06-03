//
//  Utility.h
//  FFR
//
//  Created by Passion on 7/7/15.
//  Copyright (c) 2015 MK. All rights reserved.
//

#ifndef FFR_Utility_h
#define FFR_Utility_h

#define DIF_MINS 1
#define DIF_HOURS 2
#define DIF_DAYS 3



static NSDate* dateFromISO8601String(NSString *dateString)
{
    if (!dateString) return nil;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.sZ"]; //iso 8601 format
    NSDate *output = [dateFormat dateFromString:dateString];
//    NSLog(@"Date output: %@", output);
    
    return output;
}

static NSDate* localTime(NSDate* dateUTC)
{
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    NSInteger seconds = [tz secondsFromGMTForDate: dateUTC];
    return [NSDate dateWithTimeInterval: seconds sinceDate: dateUTC];
}

static NSString* formattedDate(NSDate* date)
{
    NSString* strDate = @"";

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, dd MMM yyyy, h a"]; //iso 8601 format
    strDate = [dateFormat stringFromDate:date];
    
    
    return strDate;
}

//11 am, 11 March
static NSString* formattedDate1(NSDate* date)
{
    NSString* strDate = @"";
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"h:mm a, MMM dd yyyy"]; //iso 8601 format
    strDate = [dateFormat stringFromDate:date];
    
    
    return strDate;
}


static int differenceDates (NSDate* dateStart, int nType)
{
    NSTimeInterval secondsBetween = [dateStart timeIntervalSinceDate:localTime([NSDate date])];
    
    if (secondsBetween <= 0)
    {
        return 0;
    }
    
    int numberOfSecs = (fabs(secondsBetween) >= 0) ? fabs(secondsBetween) : 0;
    int numberOfMins = (numberOfSecs / 60 >= 0) ? numberOfSecs / 60 : 0;
    int numberOfHours = (numberOfMins / 60 >= 0) ? numberOfMins / 60 : 0;
    int numberOfDays = (numberOfHours / 24 >= 0) ? numberOfHours / 24 : 0;
    
    switch (nType)
    {
        case DIF_DAYS:
            return numberOfDays;
            break;
        case DIF_HOURS:
            return numberOfHours;
            break;
        case DIF_MINS:
            return numberOfMins;
            break;
            
        default:
            break;
    }
    
    return 0;
}

static UIStoryboard* mainStoryboard()
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
}

#endif
