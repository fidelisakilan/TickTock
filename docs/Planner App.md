#### TODO

- Add gemini prompt API to App

#### Nice to have

- Should resemble default clock alarm app
- Smile list mentioned in Adult ADHD book
- Integration with app events with google calendar

Task Class Structure

```
class TaskDetails
- title: String?
- description: String?
- startDate: TimeStamp
- repeatFrequency: RepeatFrequency
- allDay: bool
- repeats: RepeatDetails,
- reminders: List(TimeStamp)

class RepeatDetails
- interval: int
- weekdays: List(Weekday)
- endDate: DateTime?

class TimeStamp
- date: DateTime
- time: TimeOfDay

enum WeekDay {sunday, monday, tuesday, wednesday, thursday, friday, saturday}

enum RepeatFrequency {none,days,weeks,months, years,custom}
```

#### Prompt Examples

- Remind me to take medicine 5 times today in from 9 am to 9 pm
- Remind me about IT declaration every year Mar 1st 10 am
- Remind me to check LinkedIn notifications for next 3 days every evening
- Remind me to water plants everyday at 6:30 in the evening- Remind me to submit my maths assignment
  tomorrow 30 minutes before noon


```

{
title: Take the bus, 
description: Take the bus every weekday until next month, 
startDate: {
    date: 2024-08-12T00:00:00.000,
    time: 08:00
    }, 
repeatFrequency: weeks, 
allDay: false, 
repeats: {
  interval: 1, endDate: 2024-09-10T00:00:00.000, days: [monday, tuesday, wednesday, thursday, friday]
  }
}


```



```
{
  id: 23,
  title: Take
  the
  bus,
  description: null,
  startDate: {
    id: 90174829-871f-47d9-a6f9-9c947cf3c2db,
    date: {
      content: 2024-08-12
      00: 00
      :
      00.000
    },
    time: {
      hour: 8,
      minute: 0
    }
  },
  repeatFrequency: weeks,
  allDay: false,
  repeats: {
    interval: 1,
    weekdays: [
      monday,
      wednesday,
      thursday,
      friday,
      tuesday
    ],
    endDate: {
      content: 2024-09-10
      00: 00
      :
      00.000
    }
  },
  reminders: [],
  completedDates: [],
  runtimeType: default
}


```