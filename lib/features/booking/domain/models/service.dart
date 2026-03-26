class SalonService {
  final String id;
  final String name;
  final double price;
  final int durationMins;

  SalonService({
    required this.id,
    required this.name,
    required this.price,
    required this.durationMins,
  });
}

// القائمة المبدئية للخدمات والأسعار (قابلة للتعديل من لوحة التحكم)
List<SalonService> dummyServices = [
  SalonService(id: 's1', name: 'القصة الذهبيه', price: 10.0, durationMins: 50),
];
