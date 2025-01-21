import 'package:delivery/Services/searchApi.dart';
import 'package:delivery/screens/productDetailPage.dart';
import 'package:delivery/screens/productListPage.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  String selectedOption = 'Search Products'; 
    final tokens = Authmos.tokenmos; 
  final TextEditingController searchController = TextEditingController();

  void performSearch(String query) async {
    if (query.isEmpty) return;

    List<dynamic> results = [];

    try {
      if (selectedOption == 'Search Products') {
        results = await searchProducts('$tokens', query);
      } else {
        results = await searchStoresApi('$tokens', query);
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 229, 188, 244), 
          title: Text(
            'Results for "$query"',
            style: const TextStyle(color: Color.fromARGB(255, 109, 1, 98)), 
          ),
          content: results.isNotEmpty
              ? SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final item = results[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              item.name,
                              style: const TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              Navigator.of(context).pop(); 
                              if (selectedOption == 'Search Products') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(
                                      product: item, 
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductListPage(
                                      store: item, 
                                      token: '$tokens',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),Divider(thickness: 2,color: const Color.fromARGB(255, 187, 185, 185),)
                        ],
                      );
                    },
                  ),
                )
              : const Text(
                  'No results found.',
                  style: TextStyle(color: Colors.black), 
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.black), 
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      onFieldSubmitted: (value) {
        performSearch(value); 
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 240, 200, 255),
        suffixIcon: PopupMenuButton<String>(icon: const Icon(
            Icons.arrow_drop_down,
            color: Color.fromARGB(146, 109, 1, 98),
            size: 34,
          ),
          onSelected: (String value) {
            setState(() {
              selectedOption = value;
              searchController.clear(); 
            });
          },
          itemBuilder: (BuildContext context) => [
            const PopupMenuItem(
              value: 'Search Products',
              child: Text('Search Products'),
            ),
            const PopupMenuItem(
              value: 'Search Stores',
              child: Text('Search Stores'),
            ),
          ],
        ),
        hintText: selectedOption,
        hintStyle: const TextStyle(color: Color.fromARGB(146, 109, 1, 98)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 118, 45, 177),
            width: 3,
          ),
        ),
      ),
    );
  }
}