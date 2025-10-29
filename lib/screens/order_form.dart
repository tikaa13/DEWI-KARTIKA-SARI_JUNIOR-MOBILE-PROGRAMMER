import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../services/db_services.dart';

class OrderForm extends StatefulWidget {
  final Product product;
  const OrderForm({super.key, required this.product});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _phoneCtrl = TextEditingController();

  double? latitude;
  double? longitude;
  bool saving = false;

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nyalakan layanan lokasi (GPS)')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak')));
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Izin lokasi ditolak permanen. Buka pengaturan.')));
      return;
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
    });
  }

  Future<void> _saveOrder() async {
    if (!_formKey.currentState!.validate()) return;
    if (latitude == null || longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ambil lokasi terlebih dahulu')));
      return;
    }

    setState(() => saving = true);

    final order = OrderModel(
      productId: widget.product.id,
      productName: widget.product.name,
      price: widget.product.price,
      customerName: _nameCtrl.text.trim(),
      customerPhone: _phoneCtrl.text.trim(),
      latitude: latitude!,
      longitude: longitude!,
      timestamp: DateTime.now().toIso8601String(),
    );

    try {
      await DBService.instance.insertOrder(order);

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sukses'),
          content: const Text('Pesanan berhasil disimpan'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context)..pop()..pop(), child: const Text('OK'))
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Gagal'),
          content: Text('Gagal menyimpan pesanan: $e'),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Tutup'))
          ],
        ),
      );
    } finally {
      setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Pesanan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(widget.product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: 'No. HP'),
                keyboardType: TextInputType.phone,
                validator: (v) => (v == null || v.isEmpty) ? 'No. HP wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _getLocation,
                    icon: const Icon(Icons.my_location),
                    label: const Text('Ambil Lokasi'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      latitude != null ? 'Lat: ${latitude!.toStringAsFixed(5)}, Lng: ${longitude!.toStringAsFixed(5)}' : 'Lokasi belum diambil',
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              saving
                  ? const CircularProgressIndicator()
                  : SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveOrder,
                  child: const Text('Simpan Pesanan'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
