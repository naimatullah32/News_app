


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/mdels/category_model.dart';

import '../view_model/news_view_model.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}


final format= DateFormat("MMMM dd yyy");

String catName = 'general';


List<String> btnCat=[
  'General',
  'Entertainment',
  'Health',
  'Sports',
  'Business',
  'Technology'
];

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    NewsViewModel newsViewModel = NewsViewModel();
    final height = MediaQuery.of(context).size.height *1;
    final width = MediaQuery.of(context).size.width *1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: btnCat.length,
                scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        catName = btnCat[index];
                        setState(() {

                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            color: catName == btnCat[index]? Colors.grey:Colors.blue,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(child: Text(btnCat[index].toString(),
                              style: GoogleFonts.poppins(fontSize: 13,color: Colors.white) ,)),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder<CategoryModel>(
                future: newsViewModel.fetchCategoryApi(catName),
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
        ),
      ),
    );
  }
}
