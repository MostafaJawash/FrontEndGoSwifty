import 'package:delivery/Services/apifetch.dart';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/productListPage.dart';
import 'package:delivery/screens/store.dart';
import 'package:delivery/widgets/createstore.dart';
import 'package:flutter/material.dart';

class StoreListPage extends StatefulWidget {
  final bool showButtons;
  final tokens = Authmos.tokenmos;

  StoreListPage({this.showButtons = false});

  @override
  _StoreListPageState createState() => _StoreListPageState();
}

class _StoreListPageState extends State<StoreListPage> {
  late Future<List<Store>> storesFuture;
  String imagehttp = AppImage.appImage;
  final tokens = Authmos.tokenmos;

  @override
  void initState() {
    super.initState();
    storesFuture = fetchStoresApi('$tokens');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 118, 45, 177),
          centerTitle: true,
          title: Text(
           
            Language == true ? 'المتاجر' : 'Stores',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: () async {
                setState(() {
                  storesFuture = fetchStoresApi('$tokens');
                });
              },
            ),
            if (widget.showButtons)
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CreateStoreDialog(
                        token: '$tokens',
                      );
                    },
                  );
                },
              ),
          ],
        ),
        body: FutureBuilder<List<Store>>(
          future: storesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final stores = snapshot.data!;
              return Theme(
                data: Theme.of(context).copyWith(
                  listTileTheme: ListTileThemeData(
                    minVerticalPadding: 0,
                    dense: true,
                  ),
                ),
                child: ListView.builder(
                  itemCount: stores.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductListPage(
                              showButtons: widget.showButtons,
                              store: stores[index],
                              token: '$tokens',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 237, 205, 249),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 180,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  width: 100,
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey[
                                        200],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Image.network(
                                      '${stores[index].imageUrl}',
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child; 
                                        } else {
                                        
                                          Future.delayed(Duration(seconds: 1),
                                              () {
                                            
                                          });
      
                                        
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        
                                        return Image.asset(
                                         // 'lib/assest/motor.png',
                                          'lib/assest/ones.jpg',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          stores[index].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 25,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        children: [
                                          Icon(Icons.location_on),
                                          Text(
                                            '${stores[index].address}....',
                                            style: TextStyle(fontSize: 18),
                                            textDirection: TextDirection.rtl,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        stores[index].description,
                                        style: TextStyle(fontSize: 20),
                                        textDirection: TextDirection.ltr,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      if (widget.showButtons)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.edit,
                                                  color: Colors.blue),
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return EditStoreDialog(
                                                      token: '$tokens',
                                                      storeId: stores[index].id,
                                                      currentName:
                                                          stores[index].name,
                                                      currentAddress:
                                                          stores[index].address,
                                                      currentDescription:
                                                          stores[index]
                                                              .description,
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                showDeleteConfirmationDialog(
                                                  context: context,
                                                  token: '$tokens',
                                                  storeId: stores[index].id,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(child: Text('No stores found.'));
            }
          },
        ),
      ),
    );
  }
}
