class Penjualan {
  final int? PenjualanID;
  final DateTime TanggalPenjualan;
  final int TotalHarga;
  final int usrId;

  Penjualan({
    this.PenjualanID,
    required this.TanggalPenjualan,
    required this.TotalHarga,
    required this.usrId,
  });

  Map<String, dynamic> toMap() => {
        'PenjualanID': PenjualanID,
        'TanggalPenjualan': TanggalPenjualan.toIso8601String(),
        'TotalHarga': TotalHarga,
        'usrId': usrId,
      };
}
