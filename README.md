This is a small playground to compare the behavior of iOS's built-in NSDateComponentsFormatter with TTTTimeIntervalFormatter, a part of Mattt Thompson's FormatterKit. This was inspired by the Stack Overflow question on this topic: http://stackoverflow.com/questions/31686225/date-time-natural-language-approximation-in-swift/31996588#31996588 .

I was trying to understand, do the improvements in iOS mean that NSDateComponentsFormatter can now be used instead of TTTTimeIntervalFormatter, to provide colloquial descriptions of past moments?

Short answer: no.

Long answer: No, most obviously because NSDateComponentsFormatter doesn't handle past moments at all and doesn't format the present moment into a colloquial phrase. In addition, TTTTimeIntervalFormatter is configurable in various ways.

This table shows the issues:
```
   SECONDS |  TTTTimeIntervalFormatter |  NSDateComponentsFormatter
-----------+---------------------------+---------------------------
  -1488010 |               2 weeks ago |          -1 week remaining
  -1468800 |               2 weeks ago |          -1 week remaining
   -864000 |                1 week ago |        0 seconds remaining
    -86400 |                 1 day ago |           -1 day remaining
    -36000 |              10 hours ago |        -10 hours remaining
     -3600 |                1 hour ago |          -1 hour remaining
      -600 |            10 minutes ago |      -10 minutes remaining
       -60 |              1 minute ago |        -1 minute remaining
       -10 |            10 seconds ago |      -10 seconds remaining
        -1 |              1 second ago |        -1 second remaining
        -0 |                  just now |        0 seconds remaining
         0 |                  just now |        0 seconds remaining
         1 |         1 second from now |         1 second remaining
        10 |       10 seconds from now |       10 seconds remaining
        60 |         1 minute from now |         1 minute remaining
       600 |       10 minutes from now |       10 minutes remaining
      3600 |           1 hour from now |           1 hour remaining
     36000 |         10 hours from now |         10 hours remaining
     86400 |            1 day from now |            1 day remaining
    864000 |           1 week from now |           1 week remaining
   1468800 |          2 weeks from now |          2 weeks remaining
   1488010 |          2 weeks from now |          2 weeks remaining
```
