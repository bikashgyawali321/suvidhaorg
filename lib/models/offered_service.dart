class OfferedService {
  String name;
  String imageUrl;
  OfferedService({required this.name, required this.imageUrl});
}

class OfferedServiceList {
  List<OfferedService> offeredService = [
    OfferedService(name: "Barber", imageUrl: 'assets/images/barber.png'),
    OfferedService(
        name: 'Electrician', imageUrl: 'assets/images/electrician.png'),
    OfferedService(name: 'Plumber', imageUrl: 'assets/images/plumber.png'),
    OfferedService(name: 'Painter', imageUrl: 'assets/images/painter.png'),
  ];
}
