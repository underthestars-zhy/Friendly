import Foundation
import SwiftDate

/*:
Parsing dates is pretty straighforward in SwiftDate; library can parse strings with dates automatically by recognizing one of the most common patterns. Moreover you can provide your own formats or use one of the built-in parsers.
In the following chapter you will learn how to transform a string to a date.

## 2.0 - Parse Custom Format

The easiest way to transform an input string to a valid date is to use one of the `.toDate()` functions available as `String`'s instance extensions. The purpose of these method is to get the best format can represent the input string and use it to generate a valid `DateInRegion`.

As like other libs like moment.js, SwiftDate has a list of built-in formats it can use in order to obtain valid results.
You can get the list of these formats by calling `SwiftDate.autoFormats`.
The order of this array is important because SwiftDate iterates over this list until a valid date is returned (the order itself allows the lib to reduce the list of false positives).
*/
let itRegion = Region(calendar: Calendars.gregorian, zone: Zones.europeRome, locale: Locales.italian)
let enRegion = Region(calendar: Calendars.gregorian, zone: Zones.europeRome, locale: Locales.english)

let date1 = "2018-01-01 15:00".toDate()
let date2 = "15:40:50".toDate("HH:mm:ss")
let date3 = "2015-01-01 at 14".toDate("yyyy-MM-dd 'at' HH", region: itRegion)

let srcString = "July 15 - 15:30"
// it returns nil because itRegion has Locales.italian
let date4 = srcString.toDate(["yyyy-MM-dd", "MMM dd '-' HH:mm"], region: itRegion)
// it's okay because enRegion has locale set to english
let date5 = srcString.toDate(["yyyy-MM-dd", "MMM dd '-' HH:mm"], region: enRegion)
/*:
> **PERFORMANCES** In order to preserve performances you should pass the `format` parameter if you know the input format.

> **LOCALE PARAMETER** If you use readable unit names (like `MMM` for months) be sure to select the right locale inside the `region` parameter in order to get valid results.

## 2.1 Parse ISO8601
A special note must be made for ISO8601. This format (the extended version and all its variants) may include the timezone information.
If you need to parse an ISO8601 datetime you should therefore use the `.toISODate()` function of `String` in order to get a complete result.

> **NOTE** ISO8601 parser (via `.toISODate()` func) is capable of recognizing all the variants of the 8601 formats; if your date is in this formt use this function instead of passing custom time format. It will lead in better results.
*/
let date = "2017-08-05T16:04:03+02:00".toISODate(region: Region.ISO)!
// returned date's region.zone is GMT+2 not the default's Region.ISO's GMT0.
// This because value is read from the string itself.
print("Date is located in \(date.region)")
/*:
## 2.2 - Parse .NET
CSOM DateTime (aka .NET DateTime) is a format defined by Microsoft as the number of 100-nanosecond intervals that have elapsed since 12:00 A.M., January 1, 0001 ([learn more on MSDN documentation page](https://msdn.microsoft.com/en-us/library/dd948679)).

You can parse a CSOM datetime string using the `toDotNETDate()` function.

> **NOTE:** As for ISO8601 even .NET datetime may contain information about timezone. When you set the region as input parameter of the conversion function remember: it will be overriden by default parsed timezone (GMT if not specified). Region is used for `locale` only.
*/
// This is the 2017-07-22T18:27:02+02:00 date.
let date6 = "/Date(1500740822000+0200)/".toDotNETDate()!
print("Date is \(date6.toISO())")
/*:

## 2.3 - Parse RSS & AltRSS
RSS & AltRSS datetime format are used in RSS feed files. Parsing in SwiftDate is pretty easy; just call the `.toRSSDate()` function.

> **NOTE:** As for ISO8601 even RSS/AltRSS datetime contain information about timezone. When you set the region as input parameter of the conversion function remember: it will be overriden by default parsed timezone (GMT if not specified). Region is used for `locale` only.
*/
// This is the ISO8601: 2017-07-22T18:27:02+02:00
let date7 = "Sat, 22 Jul 2017 18:27:02 +0200".toRSSDate(alt: false)!
print("RSS Date is \(date7.toISO())")

// NOTE:
// Even if we set a random region with a custom locale,
// calendar and timezone, final parsed date still correct.
// Only the locale parameter is set.
// Other region's parameter are ignored and read from the string itself.
let regionAny = Region(calendar: Calendars.buddhist, zone: Zones.indianMayotte, locale: Locales.italian)
let date8 = "Tue, 20 Jun 2017 14:49:19 +0200".toRSSDate(alt: false, region: regionAny)!
print("RSS Date is \(date8.toISO())")
/*:

## 2.4 - Parse SQL
SQL datetime is the format used in all SQL-compatible schemas.
You can parse a string in this format using `toSQLDate()` function.
*/
// Date in ISO is 2016-04-14T11:58:58+02:00
let date9 = "2016-04-14T11:58:58.000+02".toSQLDate()!
print("SQL Date is \(date9.toISO())")
