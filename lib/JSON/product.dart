class Product {
  final int? ProdukID;
  final String NamaProduk;
  final String Gambar;
  final String Harga;
  final int Stok;

  Product({
    this.ProdukID,
    required this.NamaProduk,
    required this.Gambar,
    required this.Harga,
    required this.Stok,
  });

  // Factory constructor to create a Product object from a map
  factory Product.fromMap(Map<String, dynamic> json) => Product(
        ProdukID: json["ProdukID"],
        NamaProduk: json["NamaProduk"],
        Gambar: json["Gambar"],
        Harga: json["Harga"],
        Stok: json["Stok"],
      );

  // Method to convert a Product object to a map
  Map<String, dynamic> toMap() => {
        "ProdukID": ProdukID,
        "NamaProduk": NamaProduk,
        "Gambar": Gambar,
        "Harga": Harga,
        "Stok": Stok,
      };

  // Method to create a copy of the Product object with updated stock
  Product copyWith({int? id, int? stock}) {
    return Product(
      ProdukID: ProdukID ?? this.ProdukID,
      NamaProduk: this.NamaProduk,
      Gambar: this.Gambar,
      Harga: this.Harga,
      Stok: stock ?? this.Stok,
    );
  }
}
