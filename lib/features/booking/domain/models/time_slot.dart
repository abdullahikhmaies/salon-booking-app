class TimeSlot {
  final String timeText;
  final bool isBooked;

  const TimeSlot({required this.timeText, this.isBooked = false});
}

// Generate some sample slots representing a day from 10 AM to 10 PM.
// For realistic UI we can simulate currently booked times.
List<TimeSlot> generateDummySlots() {
  return [
    const TimeSlot(timeText: '12:30 PM'),
    const TimeSlot(timeText: '12:40 PM', isBooked: true),
    const TimeSlot(timeText: '12:50 PM'),
    const TimeSlot(timeText: '01:00 PM'),
    const TimeSlot(timeText: '01:10 PM', isBooked: true),
    const TimeSlot(timeText: '01:20 PM'),
    const TimeSlot(timeText: '01:30 PM'),
    const TimeSlot(timeText: '01:40 PM'),
    const TimeSlot(timeText: '01:50 PM', isBooked: true),
    const TimeSlot(timeText: '02:00 PM'),
    const TimeSlot(timeText: '02:10 PM'),
    const TimeSlot(timeText: '02:20 PM', isBooked: true),
    const TimeSlot(timeText: '02:30 PM'),
    const TimeSlot(timeText: '02:40 PM'),
    const TimeSlot(timeText: '02:50 PM'),
    const TimeSlot(timeText: '03:00 PM'),
    const TimeSlot(timeText: '03:10 PM', isBooked: true),
    const TimeSlot(timeText: '03:20 PM'),
  ];
}
