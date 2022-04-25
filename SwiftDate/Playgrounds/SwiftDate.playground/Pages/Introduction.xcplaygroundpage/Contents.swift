import Foundation
import SwiftDate
/*:
## 1.0 - Dates & Cocoa

Generally when you talk about dates you are brought to think about a particular instance of time in a particular location of the world. However, in order to get a fully generic implementationn Apple made `Date` fully indipendent from any particular geographic location, calendar or locale.

A plain `Date` object just represent an absolute value: in fact it count the number of seconds elapsed since January 1, 2001.

This is what we call **Universal Time because it represent the same moment everywhere around the world**.

You can see absolute time as the moment that someone in the USA has a telephone conversation with someone in Dubai; both have that conversation at the same moment (the absolute time) but the local time will be different due to time zones, different calendars, alphabets or notation methods.
*/
let now = Date()
print("\(now.timeIntervalSinceReferenceDate) seconds elapsed since Jan 1, 2001 @ 00:00 UTC")
/*:
However, we often need to represent a date in a more specific context: **a particular place in the world, printing them using the rules of a specified locale and more**.

In order to accomplish it we need to introduce several other objects: a `Calendar`, a `TimeZone` and a `Locale`; combining these attributes we're finally ready to provide a **representation** of the date into the real world.

SwiftDate allows you to parse, create, manipulate and inspect dates in an easy and more natural way than Cocoa itself.

## 1.1 - Region & DateInRegion

In order to simplify the date management in a specific context SwiftDate introduces two simple structs:

- `Region` is a struct which define a region in the world (`TimeZone`) a language (`Locale`) and reference calendar (`Calendar`).
- `DateInRegion` represent an absolute date in a specific region. When you work with this object all components are evaluated in the context of the region in which the object was created. Inside a DateInRegion you will have an `absoluteDate` and `region` properties.

## 1.2 - The Default Region

In SwiftDate you can work both with `DateInRegion` and `Date` instances.
Even plain Date objects uses `Region` when you need to extract time units, compare dates or evaluate specific operations.

However this is a special region called **Default Region** and - by default - it has the following attributes:

- **Time Zone** = GMT - this allows to keep a coerent behaviour with the default Date managment unless you change it.
- **Calendar** = current's device calendar (auto updating)
- **Locale** = current's device lcoale (auto updating)

While it's a good choice to always uses `DateInRegion` you can also work with `Date` by changing the default region as follow:
*/
let rome = Region(calendar: Calendars.gregorian, zone: Zones.europeRome, locale: Locales.italian)
SwiftDate.defaultRegion = rome
/*:
Since now all `Date` instances uses `rome` as default region both for parsing and evaluating date components:
*/
let dateInRome = "2018-01-01 00:00:00".toDate()!
print("Current year is \(dateInRome.year) and hour is \(dateInRome.hour)") // "Current year is 2018 and hour is 0\n"
/*:
We can still convert this date to the default absolute representation in UTC using the `convertTo(region:)` function:
*/
let dateInUTC = dateInRome.convertTo(region: Region.UTC)
print("Current year is \(dateInUTC.year) and hour is \(dateInUTC.hour)") // "Current year is 2017 and hour is 23\n"
/*:
Be careful while setting the default region.
We still reccomends to use the `DateInRegion` instances instead, this allows you to read the region explicitly.

## 1.3 - Create Region

As you seen from previous example creating a new `Region` is pretty straightforward; you need to specify the locale (used to print localized values like month or weekday name of the date), a timezone and a calendar (usually gregorian).

Region instances accept the following parameters in form of protocols:

- Time zone as `ZoneConvertible` conform object. You can pass both a `TimeZone` instance or any of the predefined timezones region defined inside the `Zones` enumeration.
- Calendar as `CalendarConvertible` conform object. You can pass both a `Calendar` instance or any of the predefined calendars available inside the `Calendars` enumeration.
- Locale as `LocaleConvertible` conform object. You can pass a both a `Locale` instance or any of the predefined locales available inside the `Locales` enumeration.

Using `Zones`, `Calendars` and `Locales` enumeration values is the easiest way to create a region and compiler can also suggest you the best match for your search.

The following example create two regions with different attributes:
*/
let regionNY = Region(calendar: Calendars.gregorian, zone: Zones.americaNewYork, locale: Locales.englishUnitedStates)
let regionTokyo = Region(calendar: Calendars.gregorian, zone: Zones.asiaTokyo, locale: Locales.japanese)
/*:
## 1.4 - Create DateInRegion
Now you are ready to create a new `DateInRegion`. There are many different ways to create a new date: parsing a string, setting time components, derivating it from another date or from a given time intervals.

Each initialization method require a region parameter which defines the region in which the date is expressed (default values may vary based upon the init and are listed below).
### 1.4.1 - From String
The most common case is to parse a string and transform it to a date. As you know `DateFormatter` is an expensive object to create and if you need to parse multiple strings you should avoid creating a new instance in your loop.
Don't worry: using SwiftDate the library helps you by reusing its own parser, shared along the caller thread.

`DateInRegion`'s `init(_:format:region)` can be used to initialize a new date from a string (various shortcut are available under the `toXXX` prefix of `String` extensions.

This object takes three parameters:

- the `string` to parse (`String`)
- the format of the string (`String`): this represent the format in which the string is expressed. It's a unicode format ([See the table of fields](7.Format_UnicodeTable.md)). If you skip this parameter SwiftDate attempts to parse the date using one of the built-in formats defined in `SwiftDate.autoFormats` array. If you know the format of the date you should explicitly set it in order to get better performances.
-  the `region` in which the date is expressed (`Region`). By default is set to `SwiftDate.defaultRegion`.
*/
let date1 = DateInRegion("2016-01-05", format: "yyyy-MM-dd", region: regionNY)
let date2 = DateInRegion("2015-09-24T13:20:55", region: regionNY)
/*:
### 1.4.2 - From Components
You can create a `DateInRegion` also by setting the date components.
The following method create a date from `DateComponents` instance passed via builder pattern:
*/
let date3 = DateInRegion(components: {
	$0.year = 2018
	$0.month = 2
	$0.day = 1
	$0.hour = 23
}, region: regionNY)
/*:
You can also instance it by passing single (optional) components:
*/
let date4 = DateInRegion(year: 2015, month: 2, day: 4, hour: 20, minute: 00, second: 00, region: regionNY)
/*:
### 1.4.3 - From TimeInterval
As plain `Date` you can create a new `DateInRegion` just passing an absolute time interval which represent the seconds/milliseconds from Unix epoch.
The following method create a date 1 year after the Unix Epoch (1971-01-01T00:00:00Z):
*/
let date5 = DateInRegion(seconds: 1.years.timeInterval, region: regionNY)
let date6 = DateInRegion(milliseconds: 5000, region: regionNY)
/*:
### 1.4.4 - From Date
Finally you can init a new `DateInRegion` directly specifyng an absolute `Date` and a destination region:
*/
let absoluteDate: Date = (Date() - 2.months).dateAt(.startOfDay)
let date7 = DateInRegion(absoluteDate, region: regionNY)
