// detail_penjualan.dart

class DetailPenjualan {
  final int? DetailID;
  final int PenjualanID;
  final int ProdukID;
  final int JumlahProduk;
  final int Subtotal;

  DetailPenjualan({
    this.DetailID,
    required this.PenjualanID,
    required this.ProdukID,
    required this.JumlahProduk,
    required this.Subtotal,
  });

  /* This method toMap converts an instance of DetailPenjualan into a map where the keys are strings and the values are dynamic */
  Map<String, dynamic> toMap() => {
        'DetailID': DetailID,
        'PenjualanID': PenjualanID,
        'ProdukID': ProdukID,
        'JumlahProduk': JumlahProduk,
        'Subtotal': Subtotal,
      };
}
