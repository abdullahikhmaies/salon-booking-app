import 'package:flutter/material.dart';
import '../../booking/domain/models/barber.dart';
import '../../../core/widgets/barber_card_shimmer.dart';

class ManageBarbersScreen extends StatefulWidget {
  const ManageBarbersScreen({super.key});

  @override
  State<ManageBarbersScreen> createState() => _ManageBarbersScreenState();
}

class _ManageBarbersScreenState extends State<ManageBarbersScreen> {
  void _addBarberDialog() {
    final TextEditingController nameController = TextEditingController();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('إضافة حلاق جديد', style: theme.textTheme.titleMedium),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              hintText: 'اسم الحلاق (مثال: أحمد)',
            ),
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
                    dummyBarbers.add(
                      Barber(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: nameController.text,
                        imageUrl:
                            'https://ui-avatars.com/api/?name=${nameController.text.replaceAll(' ', '+')}&background=1E1E1E&color=D4AF37&size=200',
                      ),
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('إضافة'),
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
        title: const Text('إدارة الحلاقين'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<Barber>>(
        future: Future.delayed(const Duration(seconds: 1), () => dummyBarbers),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4,
              itemBuilder: (_, __) => const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: BarberCardShimmer(),
              ),
            );
          }

          if (dummyBarbers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.people_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('لا يوجد حلاقين حالياً', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dummyBarbers.length,
            itemBuilder: (context, index) {
              final barber = dummyBarbers[index];
              return Dismissible(
                key: Key(barber.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  if (dummyBarbers.length <= 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('لا يمكن حذف جميع الحلاقين!'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                    return false;
                  }
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: theme.colorScheme.surface,
                        title: const Text('تأكيد الحذف'),
                        content: Text('هل أنت متأكد من حذف الحلاق "${barber.name}"؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('تأكيد الحذف', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  setState(() {
                    dummyBarbers.removeWhere((b) => b.id == barber.id);
                  });
                },
                child: Card(
                  color: theme.colorScheme.surface,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(barber.imageUrl),
                    ),
                    title: Text(
                      barber.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('تقييم: ${barber.rating} ⭐'),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: _addBarberDialog,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
