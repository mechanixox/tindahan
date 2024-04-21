import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:plantdemic/consts/app_constants.dart';
import 'package:plantdemic/providers/products_provider.dart';
import 'package:plantdemic/services/assets_manager.dart';
import 'package:plantdemic/widgets/app_name_text.dart';
import 'package:plantdemic/widgets/products/category_rounded_widget.dart';
import 'package:plantdemic/widgets/products/latest_arrival_products_widget.dart';
import 'package:plantdemic/widgets/title_text.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});



  @override
  Widget build(BuildContext context) {
      final productsProvider = Provider.of<ProductsProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: AppNameTextWidget(),
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.24,
                child: Swiper(
                  itemBuilder: (context, index) {
                    return Image.asset(
                      AppConstants.bannersImages[index],
                    );
                  },
                  itemCount: AppConstants.bannersImages.length,
                  autoplay: true,
                  pagination: SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: DotSwiperPaginationBuilder(
                        color: Colors.white,
                        activeColor: Colors.purple,
                      )),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TitlesTextWidget(
                label: "New arrivals",
                fontSize: 20,
              ),
              SizedBox(
                height: 7,
              ),
              SizedBox(
                height: size.height * 0.18,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                      value: productsProvider.getProducts[index],
                      child: LatestArrivalProductsWidget());
                  },
                ),
              ),
              //
              //
              //CATEGORIES SECTION
              //
              //
              TitlesTextWidget(
                label: "Categories",
                fontSize: 20,
              ),
              SizedBox(
                height: 10,
              ),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: List.generate(
                  AppConstants.categoriesList.length,
                  (index) {
                    return CategoryRoundedWidget(
                      image: AppConstants.categoriesList[index].images,
                      name: AppConstants.categoriesList[index].name,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
