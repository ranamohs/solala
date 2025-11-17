import 'package:solala/features/home/data/models/banners_models/banners_model.dart';
import 'package:solala/features/home/data/models/categories_models/categories_model.dart';

List<Data> getDummyBanners() {
  return [
    Data(
        id: 1,
        name: Message(ar: 'ar', en: 'en'),
        url: 'url',
        image: 'image'),
    Data(
        id: 1,
        name: Message(ar: 'ar', en: 'en'),
        url: 'url',
        image: 'image')
  ];
}

List<CategoryData> getDummyCategories() {
  return [
    CategoryData(id: 1, name: CategoryName(ar: 'فني انشاءات', en: 'kkkkkkkkkk')),
    CategoryData(id: 1, name: CategoryName(ar: 'فني انشاءات', en: 'kkkkkkkkkk')),
    CategoryData(id: 1, name: CategoryName(ar: 'فني انشاءات', en: 'kkkkkkkkkk')),
    CategoryData(id: 1, name: CategoryName(ar: 'فني انشاءات', en: 'kkkkkkkkkk')),
    CategoryData(id: 1, name: CategoryName(ar: 'فني انشاءات', en: 'kkkkkkkkkk')),
    CategoryData(id: 1, name: CategoryName(ar: 'فني انشاءات', en: 'kkkkkkkkkk')),
    CategoryData(id: 1, name: CategoryName(ar: 'فني انشاءات', en: 'kkkkkkkkkk')),
    CategoryData(id: 1, name: CategoryName(ar: 'فني انشاءات', en: 'kkkkkkkkkk')),
    CategoryData(id: 1, name: CategoryName(ar: 'فني انشاءات', en: 'kkkkkkkkkk')),
    CategoryData(id: 1, name: CategoryName(ar: 'فني انشاءات', en: 'kkkkkkkkkk')),
  ];
}

