import 'package:flutter/material.dart';

/// نموذج بيانات العنصر
class FavoriteItem {
  final String id;
  final String title;

  FavoriteItem({required this.id, required this.title});
}

/// مدير الحالة لإدارة المفضلة باستخدام Singleton
class FavoritesManager {
  // قائمة المفضلة
  final List<FavoriteItem> _favorites = [];

  // الحصول على نفس الكائن Singleton
  static final FavoritesManager _instance = FavoritesManager._internal();

  factory FavoritesManager() => _instance;

  FavoritesManager._internal();

  // الحصول على العناصر المفضلة
  List<FavoriteItem> get favorites => _favorites;

  // إضافة أو إزالة عنصر من المفضلة
  void toggleFavorite(FavoriteItem item) {
    if (_favorites.any((fav) => fav.id == item.id)) {
      _favorites.removeWhere((fav) => fav.id == item.id);
    } else {
      _favorites.add(item);
    }
  }

  // التحقق إذا كان العنصر في المفضلة
  bool isFavorite(String id) {
    return _favorites.any((fav) => fav.id == id);
  }
}

// الصفحة الرئيسية
class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final List<Map<String, String>> items = List.generate(
    10,
    (index) => {
      'id': index.toString(),
      'title': 'Item $index',
    },
  );

  @override
  Widget build(BuildContext context) {
    final manager = FavoritesManager();

    return Scaffold(
      appBar: AppBar(
        title: Text("الرئيسية"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final favoriteItem = FavoriteItem(
            id: item['id']!,
            title: item['title']!,
          );

          return ListTile(
            title: Text(item['title']!),
            trailing: IconButton(
              icon: Icon(
                manager.isFavorite(item['id']!)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: manager.isFavorite(item['id']!) ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  manager.toggleFavorite(favoriteItem);
                });
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailsPage(item: favoriteItem),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

/// صفحة تفاصيل العنصر
class ItemDetailsPage extends StatelessWidget {
  final FavoriteItem item;

  const ItemDetailsPage({required this.item});

  @override
  Widget build(BuildContext context) {
    final manager = FavoritesManager();
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل العنصر"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "تفاصيل العنصر:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("ID: ${item.id}"),
            Text("Title: ${item.title}"),
            IconButton(
              icon: Icon(
                manager.isFavorite(item.id)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: manager.isFavorite(item.id) ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                manager.toggleFavorite(item);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}/// صفحة عرض المفضلة
class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final manager = FavoritesManager();
    final favorites = manager.favorites;

    return Scaffold(
      appBar: AppBar(title: Text("المفضلة")),
      body: favorites.isEmpty
          ? Center(child: Text("لا توجد عناصر مضافة إلى المفضلة"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                return ListTile(
                  title: Text(item.title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      manager.toggleFavorite(item);
                    },
                  ),
                );
              },
            ),
    );
  }
}


class FavoriteButton extends StatefulWidget {
  final String id; // معرف العنصر
  final String title; // عنوان العنصر

  const FavoriteButton({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  final FavoritesManager manager = FavoritesManager();

  @override
  Widget build(BuildContext context) {
    final isFavorite = manager.isFavorite(widget.id);

    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          final item = FavoriteItem(id: widget.id, title: widget.title);
          manager.toggleFavorite(item);
        });
      },
    );
  }
}
// نقطة البداية للتطبيق
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: FavoriteScreen(),
  ));
}