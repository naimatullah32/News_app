import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/mdels/AryNewsHeadlines.dart';
import 'package:news_app/mdels/category_model.dart';




class NewsRepository{

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName) async{

    String url='https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=316dd9def221421fab1fcd55c2dae20e';

    final response= await http.get(Uri.parse(url));

    if (kDebugMode) {
      print(response.body);
    }

    if(response.statusCode == 200){
      final data= jsonDecode(response.body);
      return NewsChannelsHeadlinesModel.fromJson(data);
    }
    throw Exception("Error");
  }


  Future<CategoryModel> fetchCategoryApi(String category) async{

    String url='https://newsapi.org/v2/everything?q=${category}&apiKey=316dd9def221421fab1fcd55c2dae20e';

    final response= await http.get(Uri.parse(url));

    if (kDebugMode) {
      print(response.body);
    }

    if(response.statusCode == 200){
      final data= jsonDecode(response.body);
      return CategoryModel.fromJson(data);
    }
    throw Exception("Error");
  }
}