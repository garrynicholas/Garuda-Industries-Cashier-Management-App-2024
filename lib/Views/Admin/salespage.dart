import 'dart:async';
import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/JSON/penjualan.dart';
import 'package:garuda_industries/JSON/detail_penjualan.dart';
import 'package:garuda_industries/SQLite/database_helper.dart';
import 'package:intl/intl.dart';

class SalesPage extends StatefulWidget {
  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  Future<List<Penjualan>>? _salesFuture;
  final currencyFormat = NumberFormat("#,##0", "en_US");
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshSales();
  }

  void _refreshSales() {
    setState(() {
      _salesFuture = DatabaseHelper().getAllPenjualan();
    });
  }

  void _searchSales(String query) {
    setState(() {
      _salesFuture = DatabaseHelper().getAllPenjualan().then((sales) => sales
          .where((sale) =>
              sale.PenjualanID.toString().contains(query) ||
              DateFormat('yyyy-MM-dd - HH:mm')
                  .format(sale.TanggalPenjualan)
                  .contains(query) ||
              sale.TotalHarga.toString().contains(query) ||
              sale.usrId.toString().contains(query))
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sales Report",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor,
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchSales,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Cari',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                hintText: 'Cari berdasarkan ID, Tanggal, Harga.....',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Penjualan>>(
              //
              future: _salesFuture,
              // builder is to return widget
              builder: (context, snapshot) {
                // snapshot: An AsyncSnapshot object that represents the most recent interaction with the future
                /* If the connection state of the snapshot is ConnectionState.waiting, indicating that 
                the future has not yet completed, a CircularProgressIndicator is displayed at the center of the screen. */
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  /* If the snapshot has data (snapshot.hasData), the list of sales (Penjualan) objects is retrieved from the snapshot's data, or an empty list if the data is null */
                  /* In this case, the snapshot object knows about the list of Penjualan objects because it receives the result of _salesFuture, which is a Future<List<Penjualan>> */
                  List<Penjualan> penjualanList = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: penjualanList.length,
                    itemBuilder: (context, index) {
                      Penjualan penjualan = penjualanList[index];
                      return Card(
                        color: Colors.white,
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        child: ListTile(
                          title: Text('ID: ${penjualan.PenjualanID}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal: ${DateFormat('yyyy-MM-dd - HH:mm').format(penjualan.TanggalPenjualan)}',
                              ),
                              Text(
                                'Total Harga: Rp${currencyFormat.format(penjualan.TotalHarga)}',
                              ),
                              Text(
                                'Usr ID: ${penjualan.usrId}',
                              ),
                            ],
                          ),
                          onTap: () {
                            _showDetailPenjualan(context, penjualan);
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailPenjualan(BuildContext context, Penjualan penjualan) {
    int penjualanID = penjualan.PenjualanID!;
    String tanggalPenjualan = penjualan.TanggalPenjualan.toString();
    int usrId = penjualan.usrId;
    int totalHarga = penjualan.TotalHarga;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                color: const Color.fromARGB(255, 48, 48, 48),
                height: 300,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sales Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            _confirmDelete(context, penjualan);
                          },
                        ),
                      ],
                    ),
                    FutureBuilder<List<DetailPenjualan>>(
                      future:
                          DatabaseHelper().getAllDetailPenjualan(penjualanID),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<DetailPenjualan> detailPenjualanList =
                              snapshot.data ?? [];
                          return Expanded(
                            child: ListView.builder(
                              itemCount: detailPenjualanList.length,
                              itemBuilder: (context, index) {
                                DetailPenjualan detailPenjualan =
                                    detailPenjualanList[index];
                                return Card(
                                  color: backgroundColor,
                                  elevation: 3,
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    title: Text(
                                      'Detail ID: ${detailPenjualan.DetailID}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Product ID: ${detailPenjualan.ProdukID}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Jumlah Produk: ${detailPenjualan.JumlahProduk}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Subtotal: Rp${currencyFormat.format(detailPenjualan.Subtotal)}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Penjualan ID: $penjualanID',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Tanggal Penjualan: ${DateFormat('yyyy-MM-dd - HH:mm').format(penjualan.TanggalPenjualan)}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Usr ID: $usrId',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          'Total Harga: Rp${currencyFormat.format(totalHarga)}',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Penjualan penjualan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            'Delete Sales Record',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this sales record?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteSales(context, penjualan);
                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteSales(BuildContext context, Penjualan penjualan) async {
    await DatabaseHelper().deletePenjualan(penjualan.PenjualanID!);

    // Update UI by removing the deleted item from the list
    setState(() {
      _salesFuture = _salesFuture!.then((sales) {
        return sales
            .where((sale) => sale.PenjualanID != penjualan.PenjualanID)
            .toList();
      });
    });

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            'Data Deleted',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Data has been deleted.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
