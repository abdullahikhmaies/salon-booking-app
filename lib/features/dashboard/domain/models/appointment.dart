enum AppointmentType {
  appBooking,
  walkIn,
  blocked, // e.g., break time or off day
}

class Appointment {
  final String id;
  final String customerName;
  final String customerPhone;
  final String time;
  final AppointmentType type;
  final String? barberId; // للربط مع الحلاق المحدد

  const Appointment({
    required this.id,
    required this.customerName,
    this.customerPhone = '',
    required this.time,
    required this.type,
    this.barberId,
  });
}

// Dummy data for today's dashboard (Assigned to Samer ID '1')
final List<Appointment> todayAppointments = [
  const Appointment(
    id: 'a1',
    customerName: 'أحمد سعيد (عبر التطبيق)',
    customerPhone: '0791234567',
    time: '12:40 PM',
    type: AppointmentType.appBooking,
    barberId: '1',
  ),
  const Appointment(
    id: 'a2',
    customerName: 'استراحة صلاة',
    time: '01:10 PM',
    type: AppointmentType.blocked,
    barberId: '1',
  ),
  const Appointment(
    id: 'a3',
    customerName: 'محمد (بدون موعد Walk-in)',
    customerPhone: 'غير متوفر',
    time: '01:50 PM',
    type: AppointmentType.walkIn,
    barberId: '1',
  ),
  const Appointment(
    id: 'a4',
    customerName: 'سالم (عبر التطبيق)',
    customerPhone: '0779876543',
    time: '02:20 PM',
    type: AppointmentType.appBooking,
    barberId: '1',
  ),
  const Appointment(
    id: 'a5',
    customerName: 'مغلق',
    time: '03:10 PM',
    type: AppointmentType.blocked,
    barberId: '1',
  ),
];
