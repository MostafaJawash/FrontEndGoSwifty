class Store {
  final String name;
  final String imageUrl; // رابط الصورة للمتجر
  final String description;
  final List<Product> products;

  Store( this.name, this.imageUrl, this.description, this.products);
}

class Product {
  final String name;
  final String imageUrl;
  final double price;

  Product( this.name, this.imageUrl, this.price);
}
