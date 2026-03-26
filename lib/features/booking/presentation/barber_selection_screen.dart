import 'package:flutter/material.dart';
import '../domain/models/barber.dart';
import 'time_slots_screen.dart';
import '../../../core/widgets/barber_card_shimmer.dart';

class BarberSelectionScreen extends StatefulWidget {
  final String customerName;
  final String customerPhone;

  const BarberSelectionScreen({
    super.key,
    required this.customerName,
    required this.customerPhone,
  });

  @override
  State<BarberSelectionScreen> createState() => _BarberSelectionScreenState();
}

class _BarberSelectionScreenState extends State<BarberSelectionScreen> {
  Future<List<Barber>> _fetchBarbers() async {
    await Future.delayed(const Duration(seconds: 2));
    return dummyBarbers;
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('اختر حلاقك'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Salon Details Header
          Column(
            children: [
              const SizedBox(height: 16),
              Text(
                'SK Samer Ikhmies',
                style: theme.textTheme.displayLarge?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '4.9',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  Row(
                    children: List.generate(
                      5,
                      (index) =>
                          const Icon(Icons.star, color: Colors.white, size: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '(35 reviews)',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'شارع النهضة، عمّان، محافظة العاصمة',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Open · Closes at 11:45 PM',
                style: TextStyle(color: Colors.greenAccent),
              ),
              const SizedBox(height: 32),
              const Divider(color: Colors.white12),
              const SizedBox(height: 24),
              Text(
                'أختر حلاقك',
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
            ],
          ),

          FutureBuilder<List<Barber>>(
            future: _fetchBarbers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (_, __) => const Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: BarberCardShimmer(),
                  ),
                );
              }

              if (snapshot.hasError) {
                return Center(child: Text('حدث خطأ: ${snapshot.error}'));
              }

              final barbers = snapshot.data ?? [];

              if (barbers.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      const Icon(Icons.content_cut, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text('لا يوجد حلاقون متاحون حالياً', style: theme.textTheme.bodyLarge),
                    ],
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: barbers.length,
                itemBuilder: (context, index) {
                  final barber = barbers[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TimeSlotsScreen(
                            selectedBarber: barber,
                            customerName: widget.customerName,
                            customerPhone: widget.customerPhone,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Barber Avatar
                            Hero(
                              tag: 'avatar_${barber.id}',
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(barber.imageUrl),
                                backgroundColor: theme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Text and Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    barber.name,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: theme.primaryColor,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        barber.rating.toString(),
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        'متاح اليوم',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: Colors.greenAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Arrow Icon
                            Icon(
                              Icons.arrow_forward_ios,
                              color: theme.primaryColor,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
