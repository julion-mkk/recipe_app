import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recipe_app/Apis/apiCall.dart';
import 'package:recipe_app/Models/recipeModel.dart';
import 'package:recipe_app/Views/recipeView.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
    HomeState createState()=> HomeState();
}

class HomeState extends State<Home> {
    List<RecipeModel> recipeList = new List<RecipeModel>();
    TextEditingController searchController = TextEditingController();
    bool _loading = true;

    void getRecipe(String value) async {
        ApiCall apiCall = ApiCall();
        await apiCall.getRecipe(value);
        recipeList = apiCall.recipeList;
        setState(() {
            _loading = false;
        });
        print("recipeList from main : $recipeList");
    }
    @override
    build(BuildContext context) {
        return Scaffold(
            body: Stack(
                children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                    const Color(0xff213A50),
                                    const Color(0xff071930),
                                ]
                            )
                        ),
                    ),
                    SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: !kIsWeb? Platform.isIOS? 60 : 30 : 30, horizontal: 24),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Row(
                                        mainAxisAlignment: kIsWeb? MainAxisAlignment.start : MainAxisAlignment.center,
                                        children: [
                                            Text("Recipe",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    fontFamily: 'Overpass',),
                                            ),
                                            Text("App",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.blue,
                                                    fontFamily: 'Overpass'
                                                ),)
                                        ],
                                    ),
                                    SizedBox(
                                        height: 30.0,
                                    ),
                                    Text("What will you cook today?",style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                    ),
                                    SizedBox(
                                        height: 10,
                                    ),
                                    Text("Just enter ingredients you have and we will show the best recipe for you",style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white),
                                    ),
                                    SizedBox(
                                        height: 30,
                                    ),
                                    Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Row(
                                            children: [
                                                Expanded(
                                                    child: TextField(
                                                        decoration: InputDecoration(
                                                            hintText: "Enter gradient",
                                                            hintStyle: TextStyle(
                                                                color: Colors.white.withOpacity(0.5),
                                                                fontSize: 16,
                                                                fontFamily: 'Overpass'
                                                            ),
                                                            enabledBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.white)
                                                            ),
                                                            focusedBorder: UnderlineInputBorder(
                                                                borderSide: BorderSide(color: Colors.white)
                                                            )
                                                        ),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            fontFamily: 'Overpass'
                                                        ),
                                                        controller: searchController,
                                                    ),
                                                ),
                                                SizedBox(
                                                    width: 10,
                                                ),
                                                IconButton(
                                                    icon: Icon(Icons.search,color: Colors.white,),
                                                    onPressed: (){
                                                        if(searchController.text.isNotEmpty) {
                                                            getRecipe(searchController.text);
                                                        }
                                                    },
                                                )
                                            ],
                                        ),
                                    ),
                                    Container(
                                        child: GridView(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            physics: ClampingScrollPhysics(),
                                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                                maxCrossAxisExtent: 200,
                                                mainAxisSpacing: 40.0,
                                            ),
                                            children: List.generate(recipeList.length, (index) {
                                                return GridTile(
                                                    child : RecipeTile(title: recipeList[index].label, desc: recipeList[index].source, imgUrl: recipeList[index].image, url: recipeList[index].url)
                                                );
                                            }),
                                        ),
                                    )
                                ],
                            ),
                        ),
                    )
                ],
            ),
        );
    }
}

class RecipeTile extends StatefulWidget {
    final String url, desc, imgUrl, title;
    RecipeTile({this.title,this.imgUrl,this.desc,this.url});

    RecipeTileState createState()=> RecipeTileState();
}

class RecipeTileState extends State<RecipeTile> {
    _launchURL(String url) async {
        print(url);
        if (await canLaunch(url)) {
            await launch(url);
        } else {
            throw 'Could not launch $url';
        }
    }

    @override
    Widget build(BuildContext context) {
        return Wrap(
            children: <Widget>[
                GestureDetector(
                    onTap: () {
                        if (kIsWeb) {
                            _launchURL(widget.url);
                        } else {
                            print(widget.url + " this is what we are going to see");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RecipeView(
                                        postUrl: widget.url,
                                    )));
                        }
                    },
                    child: Container(
                        margin: EdgeInsets.all(8),
                        child: Stack(
                            children: <Widget>[
                                Image.network(
                                    widget.imgUrl,
                                    height: 200,
                                    width: 200,
                                    fit: BoxFit.cover,
                                ),
                                Container(
                                    width: 200,
                                    alignment: Alignment.bottomLeft,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [Colors.white30, Colors.white],
                                            begin: FractionalOffset.centerRight,
                                            end: FractionalOffset.centerLeft)),
                                    child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                                Text(
                                                    widget.title,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black54,
                                                        fontFamily: 'Overpass'),
                                                ),
                                                Text(
                                                    widget.desc,
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.black54,
                                                        fontFamily: 'OverpassRegular'),
                                                )
                                            ],
                                        ),
                                    ),
                                )
                            ],
                        ),
                    ),
                ),
            ],
        );
    }
}