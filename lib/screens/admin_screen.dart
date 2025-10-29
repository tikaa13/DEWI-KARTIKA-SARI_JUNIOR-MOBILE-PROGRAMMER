import 'package:flutter/material.dart';
import '../services/db_services.dart';
import '../models/order_model.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool loading = true;
  List<OrderModel> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() => loading = true);
    final data = await DBService.instance.fetchOrders();
    setState(() {
      orders = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Daftar Pesanan')),
      body: RefreshIndicator(
        onRefresh: _loadOrders,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : orders.isEmpty
            ? ListView(children: const [Center(child: Padding(padding: EdgeInsets.all(24.0), child: Text('Belum ada pesanan')))])
            : ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, i) {
            final o = orders[i];
            return ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text(o.productName),
              subtitle: Text('${o.customerName} • ${o.customerPhone}\nLat:${o.latitude.toStringAsFixed(5)}, Lng:${o.longitude.toStringAsFixed(5)}'),
              isThreeLine: true,
              trailing: Text('Rp ${o.price.toStringAsFixed(0)}'),
            );
          },
        ),
      ),
    );
  }
}
