import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news_app/screen/article_view.dart';

class FavNews extends StatefulWidget {
  const FavNews({super.key});

  @override
  State<FavNews> createState() => _FavNewsState();
}

class _FavNewsState extends State<FavNews> {
  final _box = Hive.box('MyNews');
  var list;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        //add back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.blue),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Text(
              "Favourite",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            Text(
              "Press",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              //open the article in a web view
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArticleView(
                    url: list[index]['url'],
                    desc: list[index]['desc'],
                  ),
                ),
              );
            },
            child: Material(
              elevation: 3.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(
                    list[index]['title'],
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    list[index]['desc'],
                    maxLines: 2,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      //delete the news from the list
                      _box.deleteAt(index);
                      //update the UI
                      setState(() {
                        getData();
                      });
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void getData() {
    //get all the data and store it in a list
    list = _box.values.toList();
  }
}
