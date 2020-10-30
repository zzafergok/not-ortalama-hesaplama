import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dersAdi;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<Ders> tumDersler;

  var formKey = GlobalKey<FormState>();
  double ortalama = 0;

  static int sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Ortalama Hesaplama'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Icon(Icons.add),
      ),
      body: uygulamaGovdesi(),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Static formu tutan container
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            //color: Colors.orange,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Ders Adi',
                      hintText: 'Ders Adini giriniz',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0) {
                        return null;
                      } else {
                        return 'Ders Adi Bos Olamaz';
                      }
                    },
                    onSaved: (kaydedilecekDeger) {
                      dersAdi = kaydedilecekDeger;
                      setState(() {
                        tumDersler.add((Ders(dersAdi,dersHarfDegeri, dersKredi)));
                        ortalama = 0;
                        ortalamayiHesapla();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            items: dersKredileriItems(),
                            value: dersKredi,
                            onChanged: (secilenKredi) {
                              setState(() {
                                dersKredi = secilenKredi;
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.green, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: DropdownButtonHideUnderline(
                          // dropDownHideUnderline widget'i dropdown'daki alt cizgi olayindan kurtariyor
                          child: DropdownButton(
                              items: dersHarfDegerleriItems(),
                              value: dersHarfDegeri,
                              onChanged: (secilenHarf) {
                                setState(() {
                                  dersHarfDegeri = secilenHarf;
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            decoration: BoxDecoration(
                border: BorderDirectional(
              top: BorderSide(color: Colors.deepOrange, width: 2),
              bottom: BorderSide(color: Colors.deepOrange, width: 2),
            )),
            child: Center(
                child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: tumDersler.length == 0 ? "Lutfen ders ekleyin" : "Ortalama : ", style: TextStyle(color: Colors.black)),
                TextSpan(
                    text: tumDersler.length == 0 ? "" : "${ortalama.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.black))
              ]),
            )),
          ),

          //Dinamik formu tutan container
          Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.blue,
                  child: ListView.builder(
                    itemBuilder: _listeElemanlariniOlustur,
                    itemCount: tumDersler.length,
            ),
          )),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];

    for (int i = 1; i <= 10; i++) {
      //var aa = DropdownMenuItem<int>(value: i, child: Text("$i Kredi"),);
      //krediler.add(aa);

      krediler.add(DropdownMenuItem<int>(
        value: i,
        child: Text("$i Kredi "),
      ));
    }

    return krediler;
  }

  List<DropdownMenuItem<double>> dersHarfDegerleriItems() {
    List<DropdownMenuItem<double>> harfler = [];

    harfler.add(DropdownMenuItem<double>(
      child: Text(
        "AA",
        style: TextStyle(fontSize: 16),
      ),
      value: 4,
    ));
    harfler.add(DropdownMenuItem<double>(
      child: Text(
        "BA",
        style: TextStyle(fontSize: 16),
      ),
      value: 3.5,
    ));
    harfler.add(DropdownMenuItem<double>(
      child: Text(
        "BB",
        style: TextStyle(fontSize: 16),
      ),
      value: 3,
    ));
    harfler.add(DropdownMenuItem<double>(
      child: Text(
        "CB",
        style: TextStyle(fontSize: 16),
      ),
      value: 2.5,
    ));
    harfler.add(DropdownMenuItem<double>(
      child: Text(
        "CC",
        style: TextStyle(fontSize: 16),
      ),
      value: 2,
    ));
    harfler.add(DropdownMenuItem<double>(
      child: Text(
        "DC",
        style: TextStyle(fontSize: 16),
      ),
      value: 1.5,
    ));
    harfler.add(DropdownMenuItem<double>(
      child: Text(
        "DD",
        style: TextStyle(fontSize: 16),
      ),
      value: 1,
    ));
    harfler.add(DropdownMenuItem<double>(
      child: Text(
        "FF",
        style: TextStyle(fontSize: 16),
      ),
      value: 0,
    ));

    return harfler;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction){
        setState(() {
          tumDersler.removeAt(index);
          ortalamayiHesapla();
        });
      },
      child: Card(
        child: ListTile(
          title: Text(tumDersler[index].ad),
          subtitle: Text(tumDersler[index].kredi.toString() +
              " kredi Ders Not Degeri: " +
              tumDersler[index].harfDegeri.toString()),
        ),
      ),
    );
  }

  void ortalamayiHesapla() {

    double toplamNot = 0;
    double toplamKredi = 0;

    for (var oankiDers in tumDersler) {

      var kredi = oankiDers.kredi;
      var harfDegeri = oankiDers.harfDegeri;

      toplamNot = toplamNot + (harfDegeri * kredi);
      toplamKredi += kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;

  Ders(this.ad, this.harfDegeri, this.kredi);
}
