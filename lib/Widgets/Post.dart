import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:photo_view/photo_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_text_view/smart_text_view.dart';

class PostCard extends StatefulWidget {
  final deviceSize;
  final profile;
  final text;
  var images;
  final video;
  final postID;
  bool liked = false;
  PostCard(
      {this.postID,
      this.deviceSize,
      this.profile,
      this.text,
      this.images,
      this.video});
  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    widget.images = [
      'https://images.freeimages.com/images/large-previews/5a9/diving-in-egypt-near-dahab-in-the-red-sea-1349043.jpg',
      'https://images.freeimages.com/images/large-previews/d89/diving-in-egypt-near-dahab-in-the-red-sea-1349190.jpg',
      'https://images.freeimages.com/images/large-previews/5ec/underwaterworld-in-the-red-sea-egypt-1429707.jpg'
    ];
    return Container(
      height: 520,
      child: Card(
        elevation: 3,
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.only(left: 8),
                leading: Container(
                  height: widget.deviceSize.height * 0.08,
                  width: widget.deviceSize.height * 0.08,
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(
                    widget.deviceSize.width * 0.025,
                    widget.deviceSize.height * 0.0,
                    widget.deviceSize.width * 0.0,
                    widget.deviceSize.height * 0.0,
                  ),
                  child: CircleAvatar(
                    radius: widget.deviceSize.height * 0.04,
                    backgroundColor: Theme.of(context).primaryColor,
                    backgroundImage: NetworkImage(
                      widget.profile.displayPicture,
                    ),
                  ),
                ),
                title: Container(
                  width: widget.deviceSize.width * 0.44,
                  margin:
                      EdgeInsets.only(right: widget.deviceSize.width * 0.05),
                  child: Text(
                    'Ziad Kamal',
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: widget.deviceSize.width * 0.046,
                        height: 0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                subtitle: Container(
                  width: widget.deviceSize.width * 0.45,
                  child: Text(
                    'yesterday',
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: widget.deviceSize.width * 0.035,
                        color: Colors.black54,
                        height: 0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ),
              Container(
                  alignment: Alignment.center,
                  width: widget.deviceSize.width * 0.7,
                  child: Divider(
                    thickness: 1,
                  )),
              Container(
                child: Container(
                  // width: widget.deviceSize.width * 0.45,
                  margin: EdgeInsets.only(
                      top: 7,
                      left: widget.deviceSize.width * 0.05,
                      right: widget.deviceSize.width * 0.04),
                  child: SmartText(
                    style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: widget.deviceSize.width * 0.045,
                        color: Colors.black,
                        height: 1),
                    text:
                        'This is my first post on safarni and it is really cooooooool application, can\'t wait to share all my traveling experience here..... #SAFARNI',
                    onOpen: (url) {},
                    onTagClick: (tag) {
                      print(tag);
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              ImagesView(
                postID: widget.postID,
                imagesURLs: widget.images,
                deviceSize: widget.deviceSize,
              ),
              SizedBox(height: 5),
              Container(
                alignment: Alignment.center,
                width: widget.deviceSize.width * 0.7,
                child: Divider(
                  thickness: 1,
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.commentDots,
                      color: Colors.black87,
                    ),
                    iconSize: 20,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      widget.liked
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      //Icons.favorite_border,
                      color: Colors.red,
                    ),
                    iconSize: 30,
                    onPressed: () {
                      setState(() {
                        widget.liked = !widget.liked;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      FontAwesomeIcons.shareSquare,
                      color: Colors.black87,
                    ),
                    iconSize: 20,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              //Container(alignment: Alignment.center,width: widget.deviceSize.width*0.3,child: Divider(thickness: 1,)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Row(
                      children: <Widget>[
                        Text(
                          '173',
                          style: TextStyle(
                              fontSize: widget.deviceSize.width * 0.04,
                              color: Colors.black54,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(FontAwesomeIcons.solidHeart,
                            color: Colors.red, size: 15),
                      ],
                    ),
                    onPressed: () {},
                  ),
                  //VerticalDivider(),
                  FlatButton(
                    child: Row(
                      children: <Widget>[
                        Text(
                          '63',
                          style: TextStyle(
                              fontSize: widget.deviceSize.width * 0.04,
                              color: Colors.black54,
                              decoration: TextDecoration.underline),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(FontAwesomeIcons.commentDots,
                            color: Colors.black87, size: 15),
                      ],
                    ),
                    onPressed: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImagesView extends StatefulWidget {
  final imagesURLs;
  final deviceSize;
  final postID;
  ImagesView({this.postID, this.imagesURLs, this.deviceSize});

  @override
  _ImagesViewState createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> {
  var imageIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 200,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, _) {
              setState(() {
                imageIndex = index;
              });
            },
          ),
          itemCount: widget.imagesURLs.length,
          itemBuilder: (BuildContext context, int itemIndex) => Container(
            child: Container(
              width: widget.deviceSize.width * 0.9,
              child: GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(new MaterialPageRoute<Null>(
                      builder: (BuildContext context) {
                        return Scaffold(
                          backgroundColor: Colors.black54,
                          appBar: AppBar(
                            automaticallyImplyLeading: true,
                            backgroundColor: Colors.black54,
                          ),
                          body: Container(
                            child: PhotoView(
                              heroAttributes: PhotoViewHeroAttributes(
                                tag: widget.postID +
                                    'image' +
                                    itemIndex.toString(),
                                transitionOnUserGestures: true,
                              ),
                              imageProvider:
                                  NetworkImage(widget.imagesURLs[itemIndex]),
                            ),
                          ),
                        );
                      },
                      fullscreenDialog: true,
                    ));
                  },
                  child: Hero(
                      tag: widget.postID + 'image' + itemIndex.toString(),
                      child: Image.network(widget.imagesURLs[itemIndex]))),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDots(),
        ),
      ],
    );
  }

  List<Widget> _buildDots() {
    List<Widget> dots = [];

    for (int i = 0; i < widget.imagesURLs.length; ++i) {
      dots.add(
        i == imageIndex
            ? Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 3.0, right: 3.0),
                  child: Container(
                    height: 10.0,
                    width: 10.0,
                    decoration: BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 0.0,
                              blurRadius: 2.0)
                        ]),
                  ),
                ),
              )
            : Container(
                child: new Padding(
                  padding: const EdgeInsets.only(left: 3.0, right: 3.0),
                  child: Container(
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                        color: Colors.grey, //Colors.deepPurple[200],
                        borderRadius: BorderRadius.circular(4.0)),
                  ),
                ),
              ),
      );
    }

    return dots;
  }
}
