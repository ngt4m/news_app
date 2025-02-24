import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_app/API_service/category_data/category_data.dart';
import 'package:new_app/API_service/news.dart';
import 'package:new_app/API_service/search_news.dart';
import 'package:new_app/API_service/slider_data.dart';
import 'package:new_app/models/article_model.dart';
import 'package:new_app/models/category_model/category_model.dart';
import 'package:new_app/models/slider_model.dart';
import 'package:new_app/ui/blog_view.dart';
import 'package:new_app/ui/category_view/category_view.dart';
import 'package:new_app/home_screen/article_view.dart';
import 'package:new_app/ui/search/search_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categorys = [];
  List<SliderModel> trendNews = [];
  List<ArticleModel> article = [];
  int activeIndex = 0;
  bool loading = true;

  @override
  void initState() {
    categorys = GetCategory();
    getSlider();
    getNews();
    super.initState();
  }

  Future<void> getNews() async {
    NewsData newsArticle = NewsData();
    await newsArticle.GetNewsData();
    setState(() {
      article = newsArticle.news;
      loading = false;
    });
  }

  Future<void> getSlider() async {
    SliderData newsSlider = SliderData();
    await newsSlider.GetSliderData();
    setState(() {
      trendNews = newsSlider.sliders;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 239, 245, 245),
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchView()),
              );
            },
            child: Icon(
              Icons.search,

            ),
          ),
        ],
        backgroundColor: Colors.blue,
        title: Text('News'),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      height: 70,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: categorys.length,
                        itemBuilder: (context, index) {
                          return CategoryView(
                              nameCategory: categorys[index].nameCategory,
                              imageCategory: categorys[index].imageCategory);
                        },
                      ),
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Padding(
                      padding: EdgeInsets.only(right: 300),
                      child: Text(
                        'Breaking News',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CarouselSlider.builder(
                      itemCount: trendNews.length,
                      itemBuilder: (context, index, real) {
                        String? name = trendNews[index].title;
                        String? image = trendNews[index].image;
                        String? link = trendNews[index].link;
                        return buildImage(image!, name!, index, link!);
                      },
                      options: CarouselOptions(
                          height: 200,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              activeIndex = index;
                            });
                          }),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    AnimatedSmoothIndicator(
                      activeIndex: activeIndex,
                      count: 5,
                      effect: JumpingDotEffect(
                        activeDotColor: Colors.blue,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ListView.builder(
                      //  physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: article.length,
                      itemBuilder: (context, index) {
                        return BlogView(
                          // description: article[index].description!,
                          image: article[index].image!,
                          title: article[index].title!,
                          publish: article[index].publish!,
                          link: article[index].link!,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildImage(String image, String name, int index, String link) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(linkArticle: link),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                image,
                height: 250,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(top: 100),
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: Colors.black26,
              ),
              child: Text(
                name,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
