class BrandMenuItem {
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final bool isBestSeller;

  const BrandMenuItem({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.isBestSeller,
  });
}

const Map<String, List<BrandMenuItem>> brandMenus = {
  'Cơm Tấm Phúc Lộc Thọ': [
    BrandMenuItem(
      name: 'Cơm tấm sườn nướng',
      price: 45000,
      imageUrl: 'https://picsum.photos/seed/plt1/200/200',
      description: 'Sườn cốt lết nướng mật ong',
      isBestSeller: true,
    ),
    BrandMenuItem(
      name: 'Cơm tấm sườn bì chả',
      price: 55000,
      imageUrl: 'https://picsum.photos/seed/plt2/200/200',
      description: 'Đầy đủ combo truyền thống',
      isBestSeller: true,
    ),
    BrandMenuItem(
      name: 'Cơm đùi gà quay',
      price: 48000,
      imageUrl: 'https://picsum.photos/seed/plt3/200/200',
      description: 'Gà quay mắm nhĩ thơm ngon',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Canh khổ qua rừng',
      price: 15000,
      imageUrl: 'https://picsum.photos/seed/plt4/200/200',
      description: 'Canh giải nhiệt tốt cho sức khỏe',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Chả trứng thêm',
      price: 10000,
      imageUrl: 'https://picsum.photos/seed/plt5/200/200',
      description: 'Chả trứng hấp truyền thống',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Trà đá sâm dứa',
      price: 5000,
      imageUrl: 'https://picsum.photos/seed/plt6/200/200',
      description: 'Thơm mùi sâm dứa',
      isBestSeller: false,
    ),
  ],
  'Phở Thìn Lò Đúc': [
    BrandMenuItem(
      name: 'Phở tái lăn',
      price: 65000,
      imageUrl: 'https://picsum.photos/seed/thin1/200/200',
      description: 'Nhiều hành, thịt bò xào tái',
      isBestSeller: true,
    ),
    BrandMenuItem(
      name: 'Phở nạm gầu',
      price: 60000,
      imageUrl: 'https://picsum.photos/seed/thin2/200/200',
      description: 'Thịt nạm giòn sần sật',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Quẩy giòn',
      price: 5000,
      imageUrl: 'https://picsum.photos/seed/thin3/200/200',
      description: 'Quẩy mới chiên mỗi ngày',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Tiết hột gà',
      price: 15000,
      imageUrl: 'https://picsum.photos/seed/thin4/200/200',
      description: 'Béo ngậy, bổ dưỡng',
      isBestSeller: true,
    ),
    BrandMenuItem(
      name: 'Trứng chần',
      price: 10000,
      imageUrl: 'https://picsum.photos/seed/thin5/200/200',
      description: 'Ăn kèm nước lèo nóng hổi',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Phở đặc biệt',
      price: 85000,
      imageUrl: 'https://picsum.photos/seed/thin6/200/200',
      description: 'Đầy đủ các loại thịt',
      isBestSeller: false,
    ),
  ],
  'Gà Rán Popeyes': [
    BrandMenuItem(
      name: '2 Miếng gà giòn',
      price: 72000,
      imageUrl: 'https://picsum.photos/seed/pop1/200/200',
      description: 'Vị Cajun cay nồng',
      isBestSeller: true,
    ),
    BrandMenuItem(
      name: 'Gà không xương',
      price: 55000,
      imageUrl: 'https://picsum.photos/seed/pop2/200/200',
      description: 'Tiện lợi, dễ ăn',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Khoai tây nghiền',
      price: 25000,
      imageUrl: 'https://picsum.photos/seed/pop3/200/200',
      description: 'Sốt gravy đặc trưng',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Burger gà',
      price: 49000,
      imageUrl: 'https://picsum.photos/seed/pop4/200/200',
      description: 'Nhân gà phi lê giòn',
      isBestSeller: true,
    ),
    BrandMenuItem(
      name: 'Bánh quy mật ong',
      price: 15000,
      imageUrl: 'https://picsum.photos/seed/pop5/200/200',
      description: 'Món phụ nổi tiếng',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Pepsi lạnh',
      price: 18000,
      imageUrl: 'https://picsum.photos/seed/pop6/200/200',
      description: 'Giải khát cực đã',
      isBestSeller: false,
    ),
  ],
  'Bún Bò Huế Xưa': [
    BrandMenuItem(
      name: 'Bún bò tái nạm',
      price: 55000,
      imageUrl: 'https://picsum.photos/seed/bbh1/200/200',
      description: 'Nước dùng đậm đà',
      isBestSeller: true,
    ),
    BrandMenuItem(
      name: 'Bún bò đặc biệt',
      price: 75000,
      imageUrl: 'https://picsum.photos/seed/bbh2/200/200',
      description: 'Có thêm giò heo và chả cua',
      isBestSeller: true,
    ),
    BrandMenuItem(
      name: 'Chả cua thêm',
      price: 15000,
      imageUrl: 'https://picsum.photos/seed/bbh3/200/200',
      description: 'Chả cua Huế chính gốc',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Bánh bột lọc',
      price: 30000,
      imageUrl: 'https://picsum.photos/seed/bbh4/200/200',
      description: 'Dai ngon, nhân tôm thịt',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Trà đào',
      price: 20000,
      imageUrl: 'https://picsum.photos/seed/bbh5/200/200',
      description: 'Thơm mát',
      isBestSeller: false,
    ),
    BrandMenuItem(
      name: 'Rau thêm',
      price: 5000,
      imageUrl: 'https://picsum.photos/seed/bbh6/200/200',
      description: 'Rau trụng hoặc rau sống',
      isBestSeller: false,
    ),
  ],
};
