import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:new_app/API_service/category_data/category_data.dart';
import 'package:new_app/API_service/news.dart';
import 'package:new_app/API_service/slider_data.dart';
import 'package:new_app/models/article_model.dart';
import 'package:new_app/models/category_model/category_model.dart';
import 'package:new_app/models/slider_model.dart';
import 'package:new_app/ui/blog_view.dart';
import 'package:new_app/ui/category_view/category_view.dart';
import 'package:new_app/ui/home_screen/article_view.dart';
import 'package:new_app/ui/login/sign_up.dart';
import 'package:new_app/ui/search/search_view.dart';
import 'package:new_app/ui/setting/setting_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Future<void> firebaseLogout(BuildContext context) async {
    try {
      // 1. Đăng xuất khỏi Firebase Auth
      await _auth.signOut();

      // 2. Xóa dữ liệu cục bộ 
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.clear(); // Hoặc xóa từng key cụ thể

      // 3. Chuyển hướng đến màn hình đăng nhập
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );

      // 4. Hiển thị thông báo
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã đăng xuất thành công')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi đăng xuất: ${e.toString()}')),
        );
      }
    }
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
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchView(),
                      ),
                    );
                  },
                  icon: Icon(Icons.search,
                  color: Colors.white,
                  size: 20,
                  ))),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 20,
            ),
            onSelected: (value) {
              if (value == 'logout') {
                firebaseLogout(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                
                value: 'logout',
                child: Text('Sign Out'),
              ),
            ],
          )
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
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                text: "Breaking  ",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                )),
                            TextSpan(
                              text: " News! ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                backgroundColor: Color.fromARGB(255, 252, 0, 0),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]),
                        )),
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
                    Text(
                      "Daily News",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
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
//
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
