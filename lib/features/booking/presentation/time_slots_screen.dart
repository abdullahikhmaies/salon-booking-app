import 'package:flutter/material.dart';
import '../domain/models/barber.dart';
import '../domain/models/time_slot.dart';
import '../../dashboard/domain/models/appointment.dart';

class TimeSlotsScreen extends StatefulWidget {
  final Barber selectedBarber;
  final String customerName;
  final String customerPhone;

  const TimeSlotsScreen({
    super.key,
    required this.selectedBarber,
    required this.customerName,
    required this.customerPhone,
  });

  @override
  State<TimeSlotsScreen> createState() => _TimeSlotsScreenState();
}

class _TimeSlotsScreenState extends State<TimeSlotsScreen> {
  final List<TimeSlot> _dailySlots = generateDummySlots();
  int _selectedDateIndex = 0; // 0 for today, 1 for tomorrow, etc.
  TimeSlot? _selectedSlot;

  // Real dynamically generated dates for the next 30 days
  final List<DateTime> _availableDates = List.generate(
    30,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  String _formatDate(DateTime date, int index) {
    if (index == 0) return 'اليوم';
    if (index == 1) return 'غداً';

    const arabicDays = {
      1: 'الإثنين',
      2: 'الثلاثاء',
      3: 'الأربعاء',
      4: 'الخميس',
      5: 'الجمعة',
      6: 'السبت',
      7: 'الأحد',
    };

    final dayName = arabicDays[date.weekday] ?? '';
    return '$dayName\n${date.day}/${date.month}';
  }

  void _confirmBooking() {
    if (_selectedSlot == null) return;

    // Simulate Confirmation Dialog
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('تأكيد الحجز', style: theme.textTheme.titleMedium),
          content: Text(
            'سيتم حجز موعد مع ${widget.selectedBarber.name} في تمام الساعة ${_selectedSlot!.timeText}\n\nهل تفضل إضافة الموعد لتقويم هاتفك؟',
            style: theme.textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: TextStyle(color: theme.textTheme.bodyMedium?.color),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // ADD TO GLOBAL APPOINTMENTS RECORD
                todayAppointments.add(
                  Appointment(
                    id: DateTime.now().toString(),
                    customerName: '${widget.customerName} (من التطبيق)',
                    customerPhone: widget.customerPhone,
                    time: _selectedSlot!.timeText,
                    type: AppointmentType.appBooking,
                    barberId: widget.selectedBarber.id,
                  ),
                );

                final navigator = Navigator.of(context);
                navigator.pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'تم الحجز بنجاح! سيصل إشعار لمدير الصالون والحلاق فوراً عبر السحابة.',
                    ),
                    backgroundColor: theme.primaryColor,
                    duration: const Duration(seconds: 4),
                  ),
                );
                // Return explicitly to login screen completely so they can login as manager to see it!
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    navigator.popUntil((route) => route.isFirst);
                  }
                });
              },
              child: const Text('تأكيد الموعد'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختيار الوقت'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Barber Info Header (Glassmorphism effect in real app, here simple container)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: theme.colorScheme.surface.withValues(alpha: 0.5),
            child: Row(
              children: [
                Hero(
                  tag: 'avatar_${widget.selectedBarber.id}',
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      widget.selectedBarber.imageUrl,
                    ),
                    radius: 25,
                    backgroundColor: theme.primaryColor,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('الحلاق المختار', style: theme.textTheme.bodyMedium),
                    Text(
                      widget.selectedBarber.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Date Selector Horizontal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'التاريخ',
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 65,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _availableDates.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedDateIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDateIndex = index;
                      _selectedSlot =
                          null; // reset time selection when date changes
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? theme.primaryColor
                            : theme.primaryColor.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _formatDate(_availableDates[index], index),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? theme.scaffoldBackgroundColor
                            : theme.textTheme.bodyLarge?.color,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        height: 1.2,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          // Time Slots Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'الأوقات المتاحة',
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              itemCount: _dailySlots.length,
              itemBuilder: (context, index) {
                final slot = _dailySlots[index];

                // If the slot is booked, apply GRAY blocked style
                if (slot.isBooked) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      slot.timeText,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  );
                }

                final isSelected = _selectedSlot == slot;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSlot = slot;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.blue // Blue when selected
                          : Colors.green.withValues(alpha: 0.1), // Green tint when available
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Colors.blue
                            : Colors.green, // Green border
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      slot.timeText,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.green, // Green text
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom CTA & Summary
          if (_selectedSlot != null)
            SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Summary',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'القصة الذهبيه',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'JOD 10',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '50 mins · with ${widget.selectedBarber.name}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white12),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total to pay',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'JOD 10',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(
                          0xFF2E8B57,
                        ), // Green color matching the "Book" button in the pic
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _confirmBooking,
                      child: Text(
                        'Book (${_selectedSlot!.timeText})',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
