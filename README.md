This is a small playground to compare the behavior of iOS's built-in NSDateFormatter with TTTTimeIntervalFormatter, a part of Mattt Thompson's FormatterKit. This was inspired by the Stack Overflow question on this topic: http://stackoverflow.com/questions/31686225/date-time-natural-language-approximation-in-swift/31996588#31996588 .

I was trying to understand, do the improvements in iOS mean that NSDateFormatter can now be used instead of TTTTimeIntervalFormatter, to provide colloquial descriptions of past moments?

Short answer: no.

Long answer: No, most obviously because NSDateFormatter doesn't handle past moments at all and doesn't format the present moment into a colloquial phrase. In addition, TTTTimeIntervalFormatter is configurable in various ways.
