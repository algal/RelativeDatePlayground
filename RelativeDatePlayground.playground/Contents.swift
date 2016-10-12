//: Playground - noun: a place where people can play

import UIKit


// known-good: Swift 3.0, Xcode 8.0

/*

The purpose of this playground is to assess whether NSDateComponentFormatter is a suitable replacement for TTTTimeIntervalFormatter.

Requirements:

- generates short, colloquial descriptions of a moment relative to the present
- must handle past as well as future moments
- basically, must be suitable for use in UIs describing timelines of past events

Conclusion:

NSDateComponentFormatter is inadequate, as of iOS9, for two reasons:
- only handles positive intervals not negative intervals!
- does not colloquialize values of 0 or near 0
- could reproduce the behavior of a default TTTTimeIntervalFormatter by manually handling the timeInterval==0 case and manually appending the approximation phrase

TTTTimeIntervalFormattea is distributed in Mattt Thompson's FormatterKit library. FormatterKit does not currently build as a cocoa touch framework, so in order to import it into a playground, I have defined a custom cocoa touch framework in this workspace. This framework, TTTTimeIntervalFormatter, contains only TTTTimeIntervalFormatter.h and TTTTimeIntervalFormatter.m, copied from version 1.8.0 of FormatterKit.

*/


import TTTTimeIntervalFormatter

extension DateComponentsFormatter {
  class func idiomaticPhraseFormatter() -> DateComponentsFormatter {
    var f =  DateComponentsFormatter()
    f.unitsStyle = .full
    f.includesApproximationPhrase = false
    f.includesTimeRemainingPhrase = true
    f.maximumUnitCount = 1
    f.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth , .month, .year]
    return f
  }
}

let formatterKitFormatter = TTTTimeIntervalFormatter()
let cocoaIdiomaticFormatter =  DateComponentsFormatter.idiomaticPhraseFormatter()

typealias DurationComponents = (seconds:Int,minutes:Int,hours:Int,days:Int,weeks:Int)

func timeIntervalForDuration(duration:DurationComponents) -> TimeInterval
{
  let (seconds,minutes,hours,days,weeks) = duration
  struct Constants  {
    static let timeUnitsAccum = (1...5).map( { [1,60,60,24,7][0..<($0)].reduce(1, *) } )
  }
  
  let pairs = zip([seconds,minutes,hours,days,weeks], Constants.timeUnitsAccum)
  let totalSecs = pairs.reduce(0) { (total:Int, p:(Int,Int)) -> Int in
    return total + p.0 * p.1
  }
  return TimeInterval(totalSecs)
}

func intervalsFromPositiveDurations(durations:[DurationComponents]) -> [TimeInterval]
{
  let positiveIntervals = durations.map(timeIntervalForDuration)
  let negativeIntervals = positiveIntervals.reversed().map({-1 * $0})
  let allIntervals = negativeIntervals + positiveIntervals
  return allIntervals
}

extension String {
  func leftPadTo(requiredCharCount:Int) -> String {
    let missingSpaces = max(0,requiredCharCount - self.characters.count)
    return repeatElement(" ", count: missingSpaces).reduce(self,{$1 + $0})
  }
}

func printRow(ss:TimeInterval) -> String
{
  let timeDouble = NSNumber(value: Double(ss)).description.leftPadTo(requiredCharCount: 20)
  let fkString = formatterKitFormatter.string(forTimeInterval: ss).leftPadTo(requiredCharCount: 25)
  let cocoaString  = (cocoaIdiomaticFormatter.string(from: ss) ?? "nil").leftPadTo(requiredCharCount: 25)
  let s = String(format: "%@ | %@ | %@", timeDouble, fkString, cocoaString)
  return s
}

func printTableFromIntervals(intervals:[TimeInterval]) -> NSAttributedString
{
  let result = intervals.map(printRow).joined(separator: "\n")
  return monotypeAttributedStringFromString(s: result)
}

func monotypeAttributedStringFromString(s:String) -> NSAttributedString
{
  let fontCourierNew = UIFont(
    descriptor: UIFontDescriptor(fontAttributes:[UIFontDescriptorFamilyAttribute:"Courier New",UIFontWeightTrait:0]),
    size: 14)
  let attrString = NSAttributedString(string: s, attributes: [NSFontAttributeName:fontCourierNew])
  return attrString
}

let positiveDurations = [
  (seconds:0, minutes: 0, hours: 0, days: 0, weeks: 0),
  (seconds:1, minutes: 0, hours: 0, days: 0, weeks: 0),
  (seconds:10, minutes: 0, hours: 0, days: 0, weeks: 0),
  (seconds:0, minutes: 1, hours: 0, days: 0, weeks: 0),
  (seconds:0, minutes: 10, hours: 0, days: 0, weeks: 0),
  (seconds:0, minutes: 0, hours: 1, days: 0, weeks: 0),
  (seconds:0, minutes: 0, hours: 10, days: 0, weeks: 0),
  (seconds:0, minutes: 0, hours: 0, days: 1, weeks: 0),
  (seconds:0, minutes: 0, hours: 0, days: 10, weeks: 0),
  (seconds:0, minutes: 0, hours: 0, days: 10, weeks: 1),
  (seconds:10, minutes: 20, hours: 5, days: 3, weeks: 2),
]

let allIntervals = intervalsFromPositiveDurations(durations: positiveDurations)

printTableFromIntervals(intervals: allIntervals)





