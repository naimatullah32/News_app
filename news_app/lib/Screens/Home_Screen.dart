import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Screens/category_Screen.dart';
import 'package:news_app/Screens/screen%20details.dart';
import 'package:news_app/mdels/AryNewsHeadlines.dart';
import 'package:news_app/view_model/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../mdels/category_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
enum filterList {bbcNews, aryNews, foxNews, ESPNCricInfo, cnn, alJazeera}

class _HomeScreenState extends State<HomeScreen> {

  filterList? selectedMenu;

  final format= DateFormat("MMMM dd yyy");

  String name = 'ary-news';

  @override
  Widget build(BuildContext context) {
    NewsViewModel newsViewModel = NewsViewModel();

    final height = MediaQuery.of(context).size.height *1;
    final width = MediaQuery.of(context).size.width *1;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen()));
          },
          icon: Image.asset("images/category_icon.png",
          height: 30,
            width: 30,
          ),
        ),
        title: Text("News",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: 24),),
        actions: [
          PopupMenuButton<filterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert,color: Colors.black,),
            onSelected: (filterList item){

              if(filterList.bbcNews.name == item.name){
                name='bbc-news';
              }
              if(filterList.aryNews.name == item.name){
                name='ary-news';
              }
              if(filterList.foxNews.name == item.name){
                name='fox-news';
              }
              if(filterList.ESPNCricInfo.name == item.name){
                name='espn-cric-info';
              }
              if(filterList.alJazeera.name == item.name){
                name='al-jazeera-english';
              }
              if(filterList.cnn.name == item.name){
                name='cnn-news';
              }

              setState(() {
                selectedMenu=item;
              });
            },

              itemBuilder: (context) => <PopupMenuEntry<filterList>>[
                PopupMenuItem<filterList>(
                    value:filterList.bbcNews ,
                    child:Text("BBC News")
                ),
                PopupMenuItem<filterList>(
                    value:filterList.aryNews ,
                    child:Text("ARY News")
                ),
                PopupMenuItem<filterList>(
                    value:filterList.foxNews ,
                    child:Text("Fox News")
                ),
                PopupMenuItem<filterList>(
                    value:filterList.ESPNCricInfo ,
                    child:Text("ESPN Cric Info")
                ),
                PopupMenuItem<filterList>(
                    value:filterList.alJazeera ,
                    child:Text("Al Jazeera English")
                ),
                PopupMenuItem<filterList>(
                    value:filterList.cnn ,
                    child:Text("CNN News")
                ),
              ])
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height *.55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
              future: newsViewModel.fetchNewsChannelHeadlinesApi(name),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitChasingDots(
                      size: 40,
                      color: Colors.blue,
                    ),
                  );
                }else{
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context , index){
                      DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                        return InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsDetailScreen(
                                snapshot.data!.articles![index].urlToImage.toString(),
                                snapshot.data!.articles![index].title.toString(),
                                snapshot.data!.articles![index].publishedAt.toString(),
                                snapshot.data!.articles![index].author.toString(),
                                snapshot.data!.articles![index].description.toString(),
                                snapshot.data!.articles![index].content.toString(),
                                snapshot.data!.articles![index].source.toString())));
                          },
                          child: SizedBox(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.6,
                                  width: width * .9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * .01
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context , url) => Container(child: spinkit2,),
                                      errorWidget: (context, url , error) => Icon(Icons.error,color: Colors.red,),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(15),
                                      alignment: Alignment.bottomCenter,
                                      height: height * .22,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width:width * 0.7 ,
                                            child: Text(snapshot.data!.articles![index].title.toString(),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            width:width * 0.7 ,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 13,fontWeight: FontWeight.w600,color: Colors.blue),
                                                ),
                                                Text(format.format(dateTime),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<CategoryModel>(
              future: newsViewModel.fetchCategoryApi('General'),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: SpinKitChasingDots(
                      size: 40,
                      color: Colors.blue,
                    ),
                  );
                }else{
                  return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical  ,
                      itemCount: snapshot.data!.articles!.length,
                      itemBuilder: (context , index){
                        DateTime dateTime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: CachedNetworkImage(
                                  imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                  fit: BoxFit.cover,
                                  height: height * .18,
                                  width: width *  .3,
                                  placeholder: (context , url) => Container(child: Center(
                                    child: SpinKitChasingDots(
                                      size: 40,
                                      color: Colors.blue,
                                    ),
                                  )),
                                  errorWidget: (context, url , error) => Icon(Icons.error,color: Colors.red,),
                                ),
                              ),
                              Expanded(

                                child: Container(
                                  height: height * .18,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    children: [
                                      Text(snapshot.data!.articles![index].title.toString(),
                                        maxLines: 3,
                                        style: GoogleFonts.poppins(
                                            fontSize: 15,color: Colors.black54,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      SizedBox(height: 50,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(snapshot.data!.articles![index].source!.name.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,color: Colors.blue,
                                              fontWeight: FontWeight.w700,

                                            ),
                                          ),
                                          Text(format.format(dateTime),
                                            style: GoogleFonts.poppins(
                                                fontSize: 11,color: Colors.black,
                                                fontWeight: FontWeight.w700
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );

                      });
                }
              },
            ),
          ),
        ],
      )
    );
  }
}

const spinkit2 = SpinKitChasingDots(
  color: Colors.amber,
  size: 40,
);