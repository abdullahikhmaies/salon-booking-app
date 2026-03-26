import 'package:flutter/material.dart';
import '../../booking/domain/models/service.dart';
import '../../../core/widgets/shimmer_loader.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  void _addOrEditServiceDialog([SalonService? existingService]) {
    final TextEditingController nameController = TextEditingController(
      text: existingService?.name ?? '',
    );
    final TextEditingController priceController = TextEditingController(
      text: existingService?.price.toString() ?? '',
    );
    final TextEditingController durationController = TextEditingController(
      text: existingService?.durationMins.toString() ?? '',
    );
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
            existingService == null ? 'إضافة خدمة جديدة' : 'تعديل الخدمة',
            style: theme.textTheme.titleMedium,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'اسم الخدمة (مثال: حلاقة شعر)',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'السعر (JOD)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'المدة (بالدقائق)'),
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
                if (nameController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    durationController.text.isNotEmpty) {
                  setState(() {
                    if (existingService != null) {
                      // Edit
                      final index = dummyServices.indexWhere(
                        (s) => s.id == existingService.id,
                      );
                      if (index != -1) {
                        dummyServices[index] = SalonService(
                          id: existingService.id,
                          name: nameController.text,
                          price: double.tryParse(priceController.text) ?? 0,
                          durationMins:
                              int.tryParse(durationController.text) ?? 0,
                        );
                      }
                    } else {
                      // Add
                      dummyServices.add(
                        SalonService(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameController.text,
                          price: double.tryParse(priceController.text) ?? 0,
                          durationMins:
                              int.tryParse(durationController.text) ?? 0,
                        ),
                      );
                    }
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('حفظ'),
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
        title: const Text('إدارة الخدمات والأسعار'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<SalonService>>(
        future: Future.delayed(const Duration(seconds: 1), () => dummyServices),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 6,
              itemBuilder: (_, __) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.1)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            ShimmerLoader(width: 120, height: 16),
                            SizedBox(height: 8),
                            ShimmerLoader(width: 80, height: 12),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const ShimmerLoader(width: 80, height: 24, borderRadius: 12),
                    ],
                  ),
                ),
              ),
            );
          }

          if (dummyServices.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.content_cut, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('لا يوجد خدمات حالياً', style: theme.textTheme.titleMedium?.copyWith(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dummyServices.length,
            itemBuilder: (context, index) {
              final service = dummyServices[index];
              return Dismissible(
                key: Key(service.id),
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
                  if (dummyServices.length <= 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('يجب ترك خدمة واحدة على الأقل!'),
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
                        content: Text('هل أنت متأكد من حذف خدمة "${service.name}"؟'),
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
                    dummyServices.removeWhere((s) => s.id == service.id);
                  });
                },
                child: Card(
                  color: theme.colorScheme.surface,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    title: Text(
                      service.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text('${service.durationMins} دقيقة'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${service.price} JOD',
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () => _addOrEditServiceDialog(service),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryColor,
        onPressed: () => _addOrEditServiceDialog(),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
