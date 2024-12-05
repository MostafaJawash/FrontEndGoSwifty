
import 'package:delivery/screens/productListPage.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';

class StoreListPage extends StatelessWidget {
  final List<Store> stores = [
    Store('Restaurant', 'lib/assest/motor.png',
        'نقدم لك أفضل المأكولات من البرجر والبيتزا.', [
      Product('برجر لذيذ', 'lib/assest/motor.png', 10.0),
      Product('بيتزا مارجريتا', 'lib/assest/motor.png', 12.0),
    ]),
    Store('Clothes', 'lib/assest/motor.png',
        'نحن نقدم ملابس عصرية وجميلة لجميع الأذواق.', [
      Product('قميص رجالي', 'lib/assest/motor.png', 25.0),
      Product('فستان نسائي', 'lib/assest/motor.png', 40.0),
    ]),
    Store('Elecotronices', 'lib/assest/motor.png',
        'أفضل الأجهزة الإلكترونية بأحدث التقنيات.', [
      Product('هاتف ذكي', 'lib/assest/motor.png', 300.0),
      Product('سماعات لاسلكية', 'lib/assest/motor.png', 50.0),
    ]),
    Store('Elecotronices', 'lib/assest/motor.png',
        'أفضل الأجهزة الإلكترونية بأحدث التقنيات.', [
      Product('هاتف ذكي', 'lib/assest/motor.png', 300.0),
      Product('سماعات لاسلكية', 'lib/assest/motor.png', 50.0),
    ]),Store('Elecotronices', 'lib/assest/motor.png',
        'أفضل الأجهزة الإلكترونية بأحدث التقنيات.', [
      Product('هاتف ذكي', 'lib/assest/motor.png', 300.0),
      Product('سماعات لاسلكية', 'lib/assest/motor.png', 50.0),
    ]),Store('Elecotronices', 'lib/assest/motor.png',
        'أفضل الأجهزة الإلكترونية بأحدث التقنيات.', [
      Product('هاتف ذكي', 'lib/assest/motor.png', 300.0),
      Product('سماعات لاسلكية', 'lib/assest/motor.png', 50.0),
    ]),
    

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 125, 239, 218),
      appBar: AppBar(
        backgroundColor:Color.fromARGB(255, 82, 92, 115),
        // Color.fromARGB(255, 65, 192, 169),
        centerTitle: true,
        title: Text('Stores' ,style: TextStyle(color: Colors.white),),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          listTileTheme: ListTileThemeData(
            minVerticalPadding: 0, // تقليل الحشو الداخلي
            dense: true, // يقلل المسافة الرأسية
          ),
        ),
        child: ListView.builder(
          itemCount: stores.length,
          itemBuilder: (context, index) {
            return Card(
            color: const Color.fromARGB(201, 255, 255, 255),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              elevation: 5,
              child: SizedBox(
                height: 160, // تثبيت الارتفاع
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      stores[index].imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    stores[index].name,
                    style: TextStyle(fontWeight: FontWeight.bold ,fontSize: 22),
                  ),
                  subtitle: Text(stores[index].description, style: TextStyle( fontSize: 20),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductListPage(store: stores[index]),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
