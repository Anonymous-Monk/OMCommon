//
//  NSDate+RHDate.m
//  MXSKit
//
//  Created by mxsheng
//  Copyright © 2023年 mxsheng. All rights reserved.
//

#import "NSDate+RHDate.h"

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);


@implementation NSDate (RHDate)

#pragma mark - 获取日历单例对象
+ (NSCalendar *)currentCalendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

+ (NSCalendar *)calendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar) {
        // 创建日历对象，指定日历的算法（公历）
        sharedCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return sharedCalendar;
}

#pragma mark - 获取当前时区(不使用夏时制)
+ (NSTimeZone *)currentTimeZone {
    // 当前时区
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    // 当前时区相对于GMT(零时区)的偏移秒数
    NSInteger interval = [localTimeZone secondsFromGMTForDate:[NSDate date]];
    // 当前时区(不使用夏时制)：由偏移量获得对应的NSTimeZone对象
    // 注意：一些夏令时时间 NSString 转 NSDate 时，默认会导致 NSDateFormatter 格式化失败，返回 null
    return [NSTimeZone timeZoneForSecondsFromGMT:interval];
}

#pragma mark - 时间戳处理/计算日期
+ (NSString *)rh_compareCureentTimeWithDate:(NSTimeInterval)timeStamp {
    
    NSDate *rh_timeDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSTimeInterval rh_timeInterval = [rh_timeDate timeIntervalSinceNow];
    rh_timeInterval = -rh_timeInterval;
    NSInteger temp = 0;
    NSCalendar *rh_calendar = [self calendar];
    NSDateComponents *rh_dateComponents = [rh_calendar components:componentFlags
                                                         fromDate:rh_timeDate];
    
    if (rh_timeInterval < 60) {
        return [NSString stringWithFormat:@"刚刚"];
    } else if((temp = rh_timeInterval / 60) < 60){
        return [NSString stringWithFormat:@"%ld分钟前", (long)temp];
    } else if((temp = rh_timeInterval / 3600) < 24){
        return [NSString stringWithFormat:@"%ld小时前", (long)temp];
    } else if ((temp = rh_timeInterval / 3600 / 24) == 1) {
        return [NSString stringWithFormat:@"昨天%ld时", (long)rh_dateComponents.hour];
    } else if ((temp = rh_timeInterval / 3600 / 24) == 2) {
        return [NSString stringWithFormat:@"前天%ld时", (long)rh_dateComponents.hour];
    } else if((temp = rh_timeInterval / 3600 / 24) < 31){
        return [NSString stringWithFormat:@"%ld天前", (long)temp];
    } else if((temp = rh_timeInterval / 3600 / 24 / 30) < 12){
        return [NSString stringWithFormat:@"%ld个月前",(long)temp];
    } else {
        return [NSString stringWithFormat:@"%ld年前", (long)temp / 12];
    }
}

+ (NSString *)rh_getCurrentTimeStamp {
    
    NSDate *rh_cureentDate = [NSDate date];
    return [NSString stringWithFormat:@"%ld", (long)[rh_cureentDate timeIntervalSince1970]];
}

+ (NSString *)rh_displayTimeWithTimeStamp:(NSTimeInterval)timeStamp {
    
    NSDate *rh_timeDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSCalendar *rh_calendar = [self calendar];
    NSDateComponents *rh_dateComponents = [rh_calendar components:componentFlags
                                                         fromDate:rh_timeDate];
    
    NSInteger rh_year   = rh_dateComponents.year;
    NSInteger rh_month  = rh_dateComponents.month;
    NSInteger rh_day    = rh_dateComponents.day;
    NSInteger rh_hour   = rh_dateComponents.hour;
    NSInteger rh_minute = rh_dateComponents.minute;
    
    return [NSString stringWithFormat:@"%ld年%ld月%ld日 %ld:%ld", (long)rh_year, (long)rh_month, (long)rh_day, (long)rh_hour, (long)rh_minute];
}

+ (NSString *)rh_displayTimeWithTimeStamp:(NSTimeInterval)timeStamp
                                formatter:(NSString *)formatter {
    
    if ([NSString stringWithFormat:@"%@", @(timeStamp)].length == 13) {
        timeStamp /= 1000.0f;
    }
    
#pragma mark --TODO 实例化各种formatter
    NSDate *rh_timeDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    NSDateFormatter *rh_dateFormatter = [[NSDateFormatter alloc] init];
    rh_dateFormatter.dateFormat = formatter;
    
    return [rh_dateFormatter stringFromDate:rh_timeDate];
}

+ (NSString *)rh_getDateStringWithDate:(NSDate *)date
                             formatter:(NSString *)formatter {
    return [self rh_getDateStringWithDate:date dateFormat:formatter timeZone:nil language:nil];
}


+ (NSString *)rh_getDateStringWithDate:(NSDate *)date
                            dateFormat:(NSString *)dateFormat
                              timeZone:(NSTimeZone *)timeZone
                              language:(NSString *)language {
    
#pragma mark --TODO 实例化各种formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    if (timeZone) {
        dateFormatter.timeZone = timeZone;
    }
    if (!language) {
        language = [NSLocale preferredLanguages].firstObject;
    }
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:language];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    return dateString;
}

/** NSString 转 NSDate */
+ (NSDate *)rh_getDateFromString:(NSString *)dateString dateFormat:(NSString *)dateFormat {
    return [self rh_getDateFromString:dateString dateFormat:dateFormat timeZone:nil language:nil];
}
/** NSString 转 NSDate */
+ (NSDate *)rh_getDateFromString:(NSString *)dateString
                      dateFormat:(NSString *)dateFormat
                        timeZone:(NSTimeZone *)timeZone
                        language:(NSString *)language {
    
#pragma mark --TODO 实例化各种formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    if (!timeZone) {
        timeZone = [self currentTimeZone];
    }
    if (!language) {
        language = [NSLocale preferredLanguages].firstObject;
    }
    dateFormatter.timeZone = timeZone;
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:language];
    // 如果当前时间不存在，就获取距离最近的整点时间
    dateFormatter.lenient = YES;
    
    return [dateFormatter dateFromString:dateString];
}

#pragma mark - 获取日期

/** 获取某个月的天数（通过年月求每月天数）*/
+ (NSUInteger)rh_getDaysInYear:(NSInteger)year month:(NSInteger)month {
    BOOL isLeapYear = year % 4 == 0 ? (year % 100 == 0 ? (year % 400 == 0 ? YES : NO) : YES) : NO;
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
        {
            return 31;
        }
        case 4:
        case 6:
        case 9:
        case 11:
        {
            return 30;
        }
        case 2:
        {
            if (isLeapYear) {
                return 29;
            } else {
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

+ (NSUInteger)rh_getEraWithDate:(NSDate *)date {
    
    NSDateComponents *rh_dateComponents = [self rh_getCalendarWithUnitFlags:NSCalendarUnitEra
                                                                       date:date];
    
    return rh_dateComponents.era;
}

+ (NSUInteger)rh_getYearWithDate:(NSDate *)date {
    
    NSDateComponents *rh_dateComponents = [self rh_getCalendarWithUnitFlags:NSCalendarUnitYear
                                                                       date:date];
    
    return rh_dateComponents.year;
}

+ (NSUInteger)rh_getMonthWithDate:(NSDate *)date {
    
    NSDateComponents *rh_dateComponents = [self rh_getCalendarWithUnitFlags:NSCalendarUnitMonth
                                                                       date:date];
    
    return rh_dateComponents.month;
}

+ (NSUInteger)rh_getDayWithDate:(NSDate *)date {
    
    NSDateComponents *rh_dateComponents = [self rh_getCalendarWithUnitFlags:NSCalendarUnitDay
                                                                       date:date];
    
    return rh_dateComponents.day;
}

+ (NSUInteger)rh_getHourWithDate:(NSDate *)date {
    
    NSDateComponents *rh_dateComponents = [self rh_getCalendarWithUnitFlags:NSCalendarUnitHour
                                                                       date:date];
    
    return rh_dateComponents.hour;
}

+ (NSUInteger)rh_getMinuteWithDate:(NSDate *)date {
    
    NSDateComponents *rh_dateComponents = [self rh_getCalendarWithUnitFlags:NSCalendarUnitMinute
                                                                       date:date];
    
    return rh_dateComponents.minute;
}

+ (NSUInteger)rh_getSecondWithDate:(NSDate *)date {
    
    NSDateComponents *rh_dateComponents = [self rh_getCalendarWithUnitFlags:NSCalendarUnitSecond
                                                                       date:date];
    
    return rh_dateComponents.second;
}

+ (NSInteger)rh_getWeekdayStringFromDate:(NSDate *)date {
    
    NSDateComponents *rh_dateComponents = [self rh_getCalendarWithUnitFlags:NSCalendarUnitWeekday
                                                                       date:date];
    
    return rh_dateComponents.weekday;
}

+ (NSInteger)rh_getDateTimeDifferenceWithBeginDate:(NSDate *)beginDate
                                           endDate:(NSDate *)endDate {
    
    NSCalendar *rh_calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *rh_dateComponents = [rh_calendar components:NSCalendarUnitDay
                                                         fromDate:beginDate
                                                           toDate:endDate
                                                          options:0];
    
    return rh_dateComponents.day;
}

//计算时间间隔秒数
+ (NSInteger)rh_calculateSecondsWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    return [endDate compareWithOtherDate:startDate];
}

//比较2个日期 返回差值秒数
- (NSTimeInterval)compareWithOtherDate:(NSDate *)date {
    //利用NSCalendar 会有误差 转成时间戳比较
    NSTimeInterval time1 = [self timeIntervalSince1970];
    NSTimeInterval time2 = [date timeIntervalSince1970];
    return (time1-time2);
}

+ (NSDate *)rh_getMonthFirstDeteWithDate:(NSDate *)date {
    
    return [self rh_getDaysDateWithDate:date
                                   days:-[self rh_getDayWithDate:date] + 1];
}

+ (NSDate *)rh_getMonthLastDayWithDate:(NSDate *)date {
    
    NSDate *rh_firstDate = [self rh_getMonthFirstDeteWithDate:date];
    NSDate *rh_monthDate = [self rh_getMonthDateWithDate:rh_firstDate
                                                  months:1];
    return [self rh_getDaysDateWithDate:rh_monthDate
                                   days:-1];
}

+ (NSUInteger)rh_getWeekOfYearWithDate:(NSDate *)date {
    
    NSUInteger rh_week = 1;
    NSUInteger rh_year = [self rh_getYearWithDate:date];
    
    NSDate *rh_lastDate = [self rh_getMonthLastDayWithDate:date];
    
    while ([self rh_getYearWithDate:[self rh_getDaysDateWithDate:rh_lastDate
                                                            days:-7 * rh_week]] == rh_year) {
        rh_week++;
    };
    
    return rh_week;
}

+ (NSDate *)rh_getTomorrowDay:(NSDate *)date {
    
    NSCalendar *rh_calendar = [self calendar];
    
    NSDateComponents *rh_dateComponents = [rh_calendar components:componentFlags
                                                         fromDate:date];
    
    rh_dateComponents.day = rh_dateComponents.day + 1;
    
    return [rh_calendar dateFromComponents:rh_dateComponents];
}

+ (NSDate *)rh_getYearDateWithDate:(NSDate *)date
                             years:(NSInteger)years {
    
    NSCalendar *rh_calendar = [self currentCalendar];

    NSDateComponents *rh_dateComponents = [[NSDateComponents alloc] init];
    
    rh_dateComponents.year = years;
    
    return [rh_calendar dateByAddingComponents:rh_dateComponents
                                        toDate:date
                                       options:0];
}

+ (NSDate *)rh_getMonthDateWithDate:(NSDate *)date
                             months:(NSInteger)months {
    
    
    NSDateComponents *rh_dateComponents = [[NSDateComponents alloc] init];
    
    rh_dateComponents.month = months;
    
    return [self rh_getDateWithDateComponents:rh_dateComponents
                                         date:date];
}

+ (NSDate *)rh_getDaysDateWithDate:(NSDate *)date
                              days:(NSInteger)days {
    
    NSDateComponents *rh_dateComponents = [[NSDateComponents alloc] init];
    
    rh_dateComponents.day = days;
    
    return [self rh_getDateWithDateComponents:rh_dateComponents
                                         date:date];
}

+ (NSDate *)rh_getHoursDateWithDate:(NSDate *)date
                              hours:(NSInteger)hours {
    
    NSDateComponents *rh_dateComponents = [[NSDateComponents alloc] init];
    
    rh_dateComponents.hour = hours;
    
    return [self rh_getDateWithDateComponents:rh_dateComponents
                                         date:date];
}

+ (NSDate *)rh_getDateWithDateComponents:(NSDateComponents *)dateComponents
                                    date:(NSDate *)date {
    
    NSCalendar *rh_calendar = [self currentCalendar];
    
    return [rh_calendar dateByAddingComponents:dateComponents
                                        toDate:date
                                       options:0];
}

#pragma mark - 日期判断
+ (BOOL)rh_isLeapYear:(NSDate *)date {
    
    NSUInteger rh_year = [self rh_getYearWithDate:date];
    
    return ((rh_year % 4 == 0) && (rh_year % 100 != 0)) || (rh_year % 400 == 0);
}

+ (BOOL)rh_checkTodayWithDate:(NSDate *)date {
    
    NSInteger rh_calendarUnit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *rh_dateComponents = [self rh_getCalendarWithUnitFlags:rh_calendarUnit
                                                                       date:date];
    
    NSDateComponents *rh_currentDateComponents = [self rh_getCalendarWithUnitFlags:rh_calendarUnit
                                                                              date:[NSDate date]];
    
    return (rh_currentDateComponents.year == rh_dateComponents.year) &&
    (rh_currentDateComponents.month == rh_dateComponents.month) &&
    (rh_currentDateComponents.day == rh_dateComponents.day);
}


#pragma mark - 获取NSDateComponents
+ (NSDateComponents *)rh_getCalendarWithUnitFlags:(NSCalendarUnit)unitFlags
                                             date:(NSDate *)date {
    
    NSCalendar *rh_calendar = [NSCalendar autoupdatingCurrentCalendar];
    
    return [rh_calendar components:unitFlags
                          fromDate:date];
}

#pragma mark - 获取工作日

- (BOOL)isWeekend {
    return [NSDate isWeekendOfDate:self];
}

- (BOOL)isWorkday {
    return ![self isWeekend];
}

+ (BOOL)isWorkdayOfDate:(NSDate *)date {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}
+ (BOOL)isWeekendOfDate:(NSDate *)date {
    return ![NSDate isWorkdayOfDate:date];
}

#pragma mark - 获取日期零点和结束
- (NSDate *)zeroDate {
    return [NSDate zeroDateOfDate:self];
}
- (NSDate *)endDate {
    return [NSDate endDateOfDate:self];
}

+ (NSDate *)zeroDateOfDate:(NSDate *)date {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:date];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate currentCalendar] dateFromComponents:components];
}
+ (NSDate *)endDateOfDate:(NSDate *)date {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:date];
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}


#pragma mark - 创建date（通过 NSCalendar 类来创建日期）
+ (NSDate *)rh_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    NSCalendar *calendar = [self calendar];
    // 获取当前日期组件
    NSDateComponents *components = [calendar components:componentFlags fromDate:[NSDate date]];
    if (year > 0) {
        // 初始化日期组件
        components = [[NSDateComponents alloc]init];
        components.year = year;
    }
    if (month > 0) {
        components.month = month;
    }
    if (day > 0) {
        components.day = day;
    }
    if (hour >= 0) {
        components.hour = hour;
    }
    if (minute >= 0) {
        components.minute = minute;
    }
    if (second >= 0) {
        components.second = second;
    }
    
    NSDate *date = [calendar dateFromComponents:components];
    
    return date;
}

+ (NSDate *)rh_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    return [self rh_setYear:year month:month day:day hour:hour minute:minute second:0];
}

+ (NSDate *)rh_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
    return [self rh_setYear:year month:month day:day hour:hour minute:0 second:0];
}

+ (NSDate *)rh_setYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    return [self rh_setYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)rh_setYear:(NSInteger)year month:(NSInteger)month {
    return [self rh_setYear:year month:month day:0 hour:0 minute:0 second:0];
}

+ (NSDate *)rh_setYear:(NSInteger)year {
    return [self rh_setYear:year month:0 day:0 hour:0 minute:0 second:0];
}

+ (NSDate *)rh_setMonth:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
    return [self rh_setYear:0 month:month day:day hour:hour minute:minute second:0];
}

+ (NSDate *)rh_setMonth:(NSInteger)month day:(NSInteger)day {
    return [self rh_setYear:0 month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)rh_setHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    return [self rh_setYear:0 month:0 day:0 hour:hour minute:minute second:second];
}

+ (NSDate *)rh_setHour:(NSInteger)hour minute:(NSInteger)minute {
    return [self rh_setYear:0 month:0 day:0 hour:hour minute:minute second:0];
}

+ (NSDate *)rh_setMinute:(NSInteger)minute second:(NSInteger)second {
    return [self rh_setYear:0 month:0 day:0 hour:0 minute:minute second:second];
}

@end
