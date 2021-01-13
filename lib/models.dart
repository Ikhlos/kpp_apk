class Warehouse {
  final int id;
  final String name;

  Warehouse({this.id, this.name});

  factory Warehouse.fromJson(Map<String, dynamic> json) {
    return Warehouse(
      id: json["id"],
      name: json["name"],
    );
  }
}

class Item {
  final String name;
  final int id;
  const Item(this.id, this.name);
}

class Factory {
  final String name;
  final int id;
  Factory({this.id, this.name});
  factory Factory.fromJson(Map<String, dynamic> json) {
    return Factory(
      id: json['id'],
      name: json['name']
    );
  }
}


class FDepartment {
  final String name;
  final int id;
  final int factory;
  FDepartment({this.id, this.name, this.factory});
  factory FDepartment.fromJson(Map<String, dynamic> json) {
    return FDepartment(
        id: json['id'],
        name: json['name'],
      factory: json['factory']
    );
  }
}


class Barcodes {
  final int id;
  final String barcode;
  final int count;



  Barcodes({this.id, this.barcode, this.count});

  factory Barcodes.fromJson(Map<String, dynamic> json) {
    return Barcodes(
      id: json['id'],
      barcode: json['barcode'],
      count: json['count'],
    );
  }


  Map<String, dynamic> toJson(){
    return {
      "id":id,
      "barcode":barcode,
      "count":count
    };
  }

}

