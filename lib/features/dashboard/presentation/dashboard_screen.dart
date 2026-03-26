import 'package:flutter/material.dart';
import '../../booking/domain/models/time_slot.dart';
import '../../booking/domain/models/barber.dart';
import '../domain/models/appointment.dart';
import 'manage_barbers_screen.dart';
import 'manage_services_screen.dart';
import '../../../core/widgets/kpi_shimmer.dart';
import '../../../core/widgets/shimmer_loader.dart';

class DashboardScreen extends StatefulWidget {
  final bool isAdmin;
  final String? barberId;

  const DashboardScreen({super.key, this.isAdmin = true, this.barberId});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // All possible slots for today (for simplicity, we reuse the generator)
  final List<TimeSlot> _dailySlots = generateDummySlots();
  late String _selectedBarberId;
  late bool _isAgendaMode;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedBarberId = widget.isAdmin
        ? dummyBarbers.first.id
        : (widget.barberId ?? dummyBarbers.first.id);
    _isAgendaMode =
        !widget.isAdmin; // Barbers default to Agenda (bookings only)
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _isLoading = false);
  }

  // Current valid appointments in the salon system
  final List<Appointment> _appointments = List.from(todayAppointments);

  void _addWalkInDialog(TimeSlot slot) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'إضافة حجز يدوي \n(${slot.timeText})',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'اسم الزبون (مثال: زبون مباشر)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'رقم الهاتف للتواصل (اختياري)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _appointments.add(
                      Appointment(
                        id: DateTime.now().toString(),
                        customerName: '${nameController.text} (بدون موعد)',
                        customerPhone: phoneController.text.isNotEmpty
                            ? phoneController.text
                            : 'غير متوفر',
                        time: slot.timeText,
                        type: AppointmentType.walkIn,
                        barberId: _selectedBarberId,
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('تم إغلاق الوقت وإضافة الزبون!'),
                      backgroundColor: theme.primaryColor,
                    ),
                  );
                }
              },
              child: const Text('حفظ واغلاق الوقت'),
            ),
          ],
        );
      },
    );
  }

  void _blockTime(TimeSlot slot) {
    setState(() {
      _appointments.add(
        Appointment(
          id: DateTime.now().toString(),
          customerName: 'مغلق (إدارة)',
          time: slot.timeText,
          type: AppointmentType.blocked,
          barberId: _selectedBarberId,
        ),
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم إغلاق وقت ${slot.timeText} عن التطبيق.'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home_rounded, color: theme.primaryColor),
          tooltip: 'الرئيسية (تسجيل الخروج)',
          onPressed: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
        title: const Text('لوحة التحكم'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: widget.isAdmin
            ? [
                IconButton(
                  icon: const Badge(
                    label: Text('3'),
                    child: Icon(Icons.notifications),
                  ),
                  onPressed: () {},
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.settings),
                  onSelected: (value) {
                    if (value == 'barbers') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageBarbersScreen(),
                        ),
                      );
                    } else if (value == 'services') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ManageServicesScreen(),
                        ),
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'barbers',
                          child: Text('إدارة الحلاقين'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'services',
                          child: Text('إدارة الخدمات والأسعار'),
                        ),
                      ],
                ),
              ]
            : [],
      ),
      body: Column(
        children: [
          // Filter & Date Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: theme.colorScheme.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.isAdmin && dummyBarbers.isNotEmpty)
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dummyBarbers.any((b) => b.id == _selectedBarberId)
                          ? _selectedBarberId
                          : dummyBarbers.first.id,
                      dropdownColor: theme.colorScheme.surface,
                      items: dummyBarbers.map((b) {
                        return DropdownMenuItem(
                          value: b.id,
                          child: Text(
                            'جدول الحلاق: ${b.name}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedBarberId = val);
                          _loadData();
                        }
                      },
                      underline: const SizedBox(),
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الجدول الزمني التفاعلي',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'حجوزاتك (مباشر)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                if (!widget.isAdmin)
                  IconButton(
                    icon: Icon(
                      _isAgendaMode ? Icons.view_day : Icons.view_agenda,
                      color: theme.primaryColor,
                    ),
                    tooltip: 'تغيير طريقة العرض',
                    onPressed: () {
                      setState(() {
                        _isAgendaMode = !_isAgendaMode;
                      });
                    },
                  ),
              ],
            ),
          ),

          if (_isLoading)
            const KpiRowShimmer()
          else if (!widget.isAdmin) 
            _buildDailyReport(theme),

          Expanded(
            child: _isLoading
                ? _buildAppointmentsShimmer(theme)
                : _isAgendaMode
                  ? _buildAgendaView(theme)
                  : _buildTimelineView(theme),
          ),
        ],
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'تم حفظ ومزامنة كافة التعديلات والحجوزات بنجاح! ✔️☁️',
                    ),
                    backgroundColor: theme.primaryColor,
                  ),
                );
              },
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.black,
              icon: const Icon(Icons.cloud_sync, size: 20),
              label: const Text(
                'حفظ ومزامنة',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  Widget _buildDailyReport(ThemeData theme) {
    final barberApps = _appointments
        .where(
          (a) =>
              a.barberId == _selectedBarberId &&
              a.type != AppointmentType.blocked,
        )
        .toList();
    final revenue = barberApps.length * 10;
    
    // As per requirement: 3 KPI Cards
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildStatItem('الإجمالي', '${_appointments.length}', Icons.list_alt, theme),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildStatItem('اليوم', '${barberApps.length}', Icons.today, theme),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildStatItem('الإيراد', '$revenue', Icons.attach_money, theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    ThemeData theme,
  ) {
    return Column(
      children: [
        Icon(icon, color: theme.primaryColor, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildAgendaView(ThemeData theme) {
    final barberApps = _appointments
        .where((a) => a.barberId == _selectedBarberId)
        .toList();
    if (barberApps.isEmpty) {
      return Center(
        child: Text(
          'لا يوجد حجوزات مسجلة لك 📭',
          style: theme.textTheme.titleMedium,
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: barberApps.length,
      itemBuilder: (context, index) {
        return _buildBookedSlot(theme, barberApps[index]);
      },
    );
  }

  Widget _buildTimelineView(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _dailySlots.length,
      itemBuilder: (context, index) {
        final slot = _dailySlots[index];
        final existingApp = _appointments
            .where(
              (app) =>
                  app.time == slot.timeText &&
                  app.barberId == _selectedBarberId,
            )
            .firstOrNull;

        if (existingApp != null) {
          return _buildBookedSlot(theme, existingApp);
        }
        return _buildEmptySlot(theme, slot);
      },
    );
  }

  Widget _buildEmptySlot(ThemeData theme, TimeSlot slot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white12,
          width: 1,
        ), // dashed-like feeling
      ),
      child: Row(
        children: [
          // Time badge
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              slot.timeText,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 16),
          // Actions
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _addWalkInDialog(slot),
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('حجز يدوي'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.primaryColor,
                    side: BorderSide(
                      color: theme.primaryColor.withValues(alpha: 0.5),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => _blockTime(slot),
                  icon: const Icon(Icons.block, size: 18),
                  label: const Text('إغلاق'),
                  style: TextButton.styleFrom(foregroundColor: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookedSlot(ThemeData theme, Appointment app) {
    Color badgeColor;
    IconData icon;

    String statusText;
    switch (app.type) {
      case AppointmentType.appBooking:
        badgeColor = const Color(0xFF4CAF50); // Green for app
        icon = Icons.app_shortcut;
        statusText = 'مؤكد (تطبيق)';
        break;
      case AppointmentType.walkIn:
        badgeColor = theme.primaryColor; // Gold for manual walk-in
        icon = Icons.directions_walk;
        statusText = 'مكتمل (بدون موعد)';
        break;
      case AppointmentType.blocked:
        badgeColor = theme.colorScheme.error; // Red for blocked
        icon = Icons.block;
        statusText = 'ملغى / مغلق';
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: badgeColor.withValues(alpha: 0.5), width: 1),
      ),
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: badgeColor.withValues(alpha: 0.2),
          child: Icon(icon, color: badgeColor),
        ),
        title: Text(
          app.customerName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            decoration: app.type == AppointmentType.blocked
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (app.type != AppointmentType.blocked &&
                app.customerPhone.isNotEmpty)
              Text(app.customerPhone, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 4),
            Text(app.time, style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: Chip(
          label: Text(
            statusText,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          backgroundColor: badgeColor.withValues(alpha: 0.2),
          side: BorderSide.none,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildAppointmentsShimmer(ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const ShimmerLoader(width: 40, height: 40, borderRadius: 20),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerLoader(width: 150, height: 16),
                      SizedBox(height: 8),
                      ShimmerLoader(width: 100, height: 14),
                      SizedBox(height: 8),
                      ShimmerLoader(width: 60, height: 12),
                    ],
                  ),
                ),
                const ShimmerLoader(width: 60, height: 24, borderRadius: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
