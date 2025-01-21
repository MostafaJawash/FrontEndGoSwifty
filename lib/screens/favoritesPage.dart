import 'package:delivery/Services/apiLiked.dart';
import 'package:delivery/screens/globals.dart';
import 'package:delivery/screens/productDetailPage.dart';
import 'package:delivery/screens/store.dart';
import 'package:flutter/material.dart';

class FavoriteItem {
  final String id;
  final String title;
  final Product product;

  FavoriteItem({required this.id, required this.title, required this.product});
}

class FavoritesManager {
  final List<FavoriteItem> _favorites = [];

  static final FavoritesManager _instance = FavoritesManager._internal();

  factory FavoritesManager() => _instance;

  FavoritesManager._internal();

  List<FavoriteItem> get favorites => _favorites;

  void addFavorite(FavoriteItem item) {
    if (!_favorites.any((fav) => fav.id == item.id)) {
      _favorites.add(item);
    }
  }

  void removeFavorite(String id) {
    _favorites.removeWhere((fav) => fav.id == id);
  }

  bool isFavorite(String id) {
    return _favorites.any((fav) => fav.id == id);
  }

  void toggleFavorite(FavoriteItem item) {
    if (isFavorite(item.id)) {
      removeFavorite(item.id);
    } else {
      addFavorite(item);
    }
  }

  void setFavoritesFromAPI(List<Product> products) {
    _favorites.clear();
    for (var product in products) {
      _favorites.add(FavoriteItem(
        id: product.id,
        title: product.name,
        product: product,
      ));
    }
  }
}

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FavoritesManager manager = FavoritesManager();
  bool _isLoading = true;
  final tokens = Authmos.tokenmos;
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    String token = '$tokens';

    try {
      final products = await fetchLikedProducts(token);
      setState(() {
        manager.setFavoritesFromAPI(products);
        _isLoading = false;
      });
    } catch (e) {
      print("Error loading favorites: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  String imagehttp = AppImage.appImage;
  @override
  Widget build(BuildContext context) {
    final favorites = manager.favorites;

    return Directionality(
      textDirection: Language == true ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        //backgroundColor: const Color.fromARGB(255, 23, 27, 51),
        appBar: AppBar(
          title: Text(Language == true ? 'المفضلة' : 'Favorites',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 88, 31, 132),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : favorites.isEmpty
                ? Center(
                    child: Text(
                    Language == true
                        ? "لا توجد عناصر مضافة إلى المفضلة"
                        : 'There are no items added to favorites',
                  ))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 3 / 4,
                      ),
                      itemCount: favorites.length,
                      itemBuilder: (context, index) {
                        final item = favorites[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailPage(product: item.product),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromARGB(255, 138, 138, 138)
                                      .withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                               
                                Center(
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.grey[
                                          200], 
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        '${item.product.imageUrl}',
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
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                         
                                          return Image.asset(
                                            // 'lib/assest/motor.png',
                                            'lib/assest/stor.jpeg',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        "\$${item.product.price.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      String token = '$tokens';
                                      await likeOrDislikeProduct(
                                        token: token,
                                        productId: item.id,
                                      );
                                      setState(() {
                                        manager.toggleFavorite(item);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final String id;
  final String title;
  final Product product;

  const FavoriteButton({
    Key? key,
    required this.id,
    required this.title,
    required this.product,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FavoritesManager manager = FavoritesManager();
  bool isFavorite = false;
  final tokens = Authmos.tokenmos;
  @override
  void initState() {
    super.initState();
    isFavorite = manager.isFavorite(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: () async {
        String token = '$tokens';

        try {
          final responseMessage = await likeOrDislikeProduct(
            token: token,
            productId: widget.id,
          );

          setState(() {
            if (responseMessage == "Liked") {
              isFavorite = true;
              final item = FavoriteItem(
                id: widget.id,
                title: widget.title,
                product: widget.product,
              );
              manager.addFavorite(item);
            } else if (responseMessage == "Disliked") {
              isFavorite = false;
              manager.removeFavorite(widget.id);
            }
          });
        } catch (e) {
          print("Error: $e");
        }
      },
    );
  }
}
