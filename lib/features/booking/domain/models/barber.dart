class Barber {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;

  Barber({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.rating = 5.0,
  });
}

// القائمة المبدئية للحلاقين (المدير يقدر يضيف ويحذف منها لاحقا)
List<Barber> dummyBarbers = [
  Barber(
    id: '1',
    name: 'سامر إخميس',
    imageUrl:
        'https://ui-avatars.com/api/?name=Samer+Ikhmies&background=1E1E1E&color=D4AF37&size=200',
    rating: 4.9,
  ),
];
