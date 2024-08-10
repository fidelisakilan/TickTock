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