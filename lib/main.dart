import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nisnController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController bulanController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController rincianController = TextEditingController();

  String pesanSukses = '';

  Future<void> kirimData(BuildContext context) async {
    final url =
        Uri.parse('http://192.168.43.199/api_produk/laporkjp/create.php');

    final response = await http.post(
      url,
      body: {
        'nisn': nisnController.text,
        'nama': namaController.text,
        'kelas': kelasController.text,
        'bulan': bulanController.text,
        'tanggal': tanggalController.text,
        'rincian': rincianController.text,
      },
    );

    if (response.statusCode == 200) {
      print('Data terkirim dengan sukses');
      setState(() {
        pesanSukses = 'Data Terkirim';
        nisnController.clear();
        namaController.clear();
        kelasController.clear();
        bulanController.clear();
        tanggalController.clear();
        rincianController.clear();
      });
      tampilkanDialogSukses(context);
    } else {
      print('Gagal mengirim data. Kode status: ${response.statusCode}');
      tampilkanSnackBar(context, 'Gagal mengirim data. Silakan coba lagi.');
    }
  }

  void tampilkanDialogSukses(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text(pesanSukses),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  pesanSukses = '';
                });
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void tampilkanSnackBar(BuildContext context, String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pesan),
        duration: Duration(seconds: 3),
      ),
    );
  }

  bool validasiData() {
    return nisnController.text.isNotEmpty &&
        namaController.text.isNotEmpty &&
        kelasController.text.isNotEmpty &&
        bulanController.text.isNotEmpty &&
        tanggalController.text.isNotEmpty &&
        rincianController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SDN MARUNDA 01 PAGI'),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'LAPORAN PENERIMAAN DAN PENGGUNAAN KJP 2024',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: nisnController,
                decoration: InputDecoration(labelText: 'NISN Siswa'),
              ),
              TextField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Siswa'),
              ),
              TextField(
                controller: kelasController,
                decoration: InputDecoration(labelText: 'Kelas'),
              ),
              TextField(
                controller: bulanController,
                decoration: InputDecoration(labelText: 'Bulan Pelaporan'),
              ),
              TextField(
                controller: tanggalController,
                decoration: InputDecoration(labelText: 'Tanggal Pelaporan'),
                onTap: () async {
                  DateTime? date = DateTime.now();
                  FocusScope.of(context).requestFocus(new FocusNode());

                  date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (date != null && date != DateTime.now()) {
                    String tanggalFormatted =
                        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                    tanggalController.text = tanggalFormatted;
                  }
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: rincianController,
                decoration: InputDecoration(labelText: 'Rincian Penggunaan'),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (validasiData()) {
                        kirimData(context);
                      } else {
                        tampilkanSnackBar(
                            context, 'Harap isi data dengan benar');
                      }
                    },
                    child: Text('KIRIM'),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DataPage()),
                      );
                    },
                    child: Text('DATA PELAPORAN'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
