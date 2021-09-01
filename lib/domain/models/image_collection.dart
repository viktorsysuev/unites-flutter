class EventImagesModel {
  EventImagesModel({required this.id, required this.imagesPath});

  String id;
  List<String> imagesPath;

  static EventImagesModel fromJson(Map<String, dynamic> json) {
    final List<dynamic> list = json['imagesPath'];
    final res = <String>[];
    for(var item in list){
      res.add(item);
    }
    return EventImagesModel(id: json['id'], imagesPath: res);
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'imagesPath': imagesPath};
  }
}
