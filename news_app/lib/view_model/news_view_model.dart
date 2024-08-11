

import 'package:news_app/Repository/news_repository.dart';
import 'package:news_app/mdels/AryNewsHeadlines.dart';
import 'package:news_app/mdels/category_model.dart';
// import 'package:news_app/mdels/NewsChannelHeadlinesModel.dart';
// import 'package:news_app/mdels/NewsChannelHeadlines.dart';
class NewsViewModel{

  final _repo = NewsRepository();

  Future<NewsChannelsHeadlinesModel> fetchNewsChannelHeadlinesApi(String channelName)async{
    final response=await _repo.fetchNewsChannelHeadlinesApi(channelName);
    return response;
  }


  Future<CategoryModel> fetchCategoryApi(String category)async{
    final response=await _repo.fetchCategoryApi(category);
    return response;
  }
}