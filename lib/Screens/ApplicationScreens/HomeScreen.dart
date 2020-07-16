import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hashtagable/hashtag_editable_text.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.widget.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:safarni/View_Models/AuthenticationViewModel.dart';
import 'package:safarni/Widgets/Post.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final images = [
    'https://images.freeimages.com/images/large-previews/5a9/diving-in-egypt-near-dahab-in-the-red-sea-1349043.jpg',
    //'https://images.freeimages.com/images/large-previews/d89/diving-in-egypt-near-dahab-in-the-red-sea-1349190.jpg',
    //'https://images.freeimages.com/images/large-previews/5ec/underwaterworld-in-the-red-sea-egypt-1429707.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final provider = Provider.of<AuthenticationViewModel>(context);
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 7),
        child: FloatingActionButton(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              TextEditingController _textController = TextEditingController();
              
              pushDynamicScreen(
                context,
                withNavBar: false,
                screen: showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return Container(
                        height: deviceSize.height * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: deviceSize.width * 0.05,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black87,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'New Post',
                                        style: TextStyle(
                                          fontFamily: 'Cairo',
                                          fontSize: deviceSize.width * 0.05,
                                        ),
                                      )),
                                ],
                              ),
                              Container(
                                child: Divider(
                                  thickness: 1,
                                ),
                                width: deviceSize.width * 0.7,
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    height: deviceSize.height * 0.08,
                                    width: deviceSize.height * 0.08,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(
                                      deviceSize.width * 0.05,
                                      deviceSize.height * 0.02,
                                      deviceSize.width * 0.0,
                                      deviceSize.height * 0.0,
                                    ),
                                    child: CircleAvatar(
                                      radius: deviceSize.height * 0.04,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      backgroundImage: NetworkImage(
                                        provider
                                            .profileViewModel.displayPicture,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: deviceSize.width * 0.44,
                                        margin: EdgeInsets.only(
                                            left: deviceSize.width * 0.04),
                                        child: Text(
                                          'Ziad Kamal',
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize: deviceSize.width * 0.05,
                                              height: 1),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: deviceSize.width * 0.44,
                                        margin: EdgeInsets.only(
                                            left: deviceSize.width * 0.04),
                                        child: Text(
                                          'ziadshebl',
                                          style: TextStyle(
                                              fontFamily: 'Cairo',
                                              fontSize:
                                                  deviceSize.width * 0.035,
                                              height: 1,
                                              color: Colors.black54),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Scrollbar(
                                child:Container(
                                  padding: EdgeInsets.all(10),
                                  width: deviceSize.width * 0.9,
                                  margin:
                                      EdgeInsets.all(deviceSize.height * 0.01),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black54,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: HashTagEditableText(
                                    minLines: 1,
                                    maxLines: 4,
                                    controller: _textController,
                                    basicStyle: TextStyle(color: Colors.blue),
                                    decoratedStyle:
                                        TextStyle(color: Colors.black87),
                                    hintText: 'What is your latest adventure?',  
                                    hintTextStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
                                    // decoration: InputDecoration(
                                    //   prefixIcon: Icon(
                                    //     FontAwesomeIcons.commentAlt,
                                    //     size: 17,
                                    //     color: Colors.black54,
                                    //   ),
                                    //   hintMaxLines: 1,
                                    //   labelText:
                                    //       'What is your latest adventure?',
                                    //   filled: true,
                                    //   fillColor:
                                    //       Colors.white.withOpacity(0.7),
                                    //   border: OutlineInputBorder(
                                    //     borderSide:
                                    //         BorderSide(color: Colors.black87),
                                    //     borderRadius:
                                    //         BorderRadius.circular(15.0),
                                    //   ),
                                    //   focusedBorder: OutlineInputBorder(
                                    //       borderRadius: BorderRadius.all(
                                    //           Radius.circular(15.0)),
                                    //       borderSide: BorderSide(
                                    //           color: Colors.black87)),
                                    //   labelStyle:
                                    //       TextStyle(color: Colors.black54),
                                    // ),
                                    // textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.multiline,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.photoVideo,
                                          size: 20,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('Add Photos',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline))
                                      ],
                                    ),
                                    onPressed: () {},
                                  ),
                                  Container(
                                    height: 20,
                                    child: VerticalDivider(
                                      color: Colors.black54,
                                      thickness: 0.6,
                                    ),
                                  ),
                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.video_call,
                                          size: 23,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          'Add Video',
                                          style: TextStyle(
                                              color: Colors.blue,
                                              decoration:
                                                  TextDecoration.underline),
                                        )
                                      ],
                                    ),
                                    onPressed: () {},
                                  )
                                ],
                              ),
                              AddPostImagesView(
                                imagesURLs: images,
                                deviceSize: deviceSize,
                              ),
                              Container(
                                alignment: Alignment.bottomRight,
                                margin: EdgeInsets.only(
                                    right: 30, top: 15, bottom: 20),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  color: Colors.deepPurple,
                                  child: Text(
                                    'POST',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              );
            },
            backgroundColor: Colors.deepPurple),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            PostCard(
              postID: '1',
              deviceSize: deviceSize,
              profile: provider.profileViewModel,
            ),
            PostCard(
              postID: '2',
              deviceSize: deviceSize,
              profile: provider.profileViewModel,
            ),
            PostCard(
              postID: '3',
              deviceSize: deviceSize,
              profile: provider.profileViewModel,
            ),
            PostCard(
              postID: '4',
              deviceSize: deviceSize,
              profile: provider.profileViewModel,
            ),
            PostCard(
              postID: '5',
              deviceSize: deviceSize,
              profile: provider.profileViewModel,
            ),
            PostCard(
              postID: '6',
              deviceSize: deviceSize,
              profile: provider.profileViewModel,
            ),
            PostCard(
              postID: '7',
              deviceSize: deviceSize,
              profile: provider.profileViewModel,
            ),
          ],
        ),
      ),
    );
  }
}

class AddPostImagesView extends StatefulWidget {
  final imagesURLs;
  final deviceSize;
  AddPostImagesView({this.imagesURLs, this.deviceSize});

  @override
  _AddPostImagesViewState createState() => _AddPostImagesViewState();
}

class _AddPostImagesViewState extends State<AddPostImagesView> {
  var imageIndex;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.imagesURLs.length > 1
            ? CarouselSlider.builder(
                options: CarouselOptions(
                  height: 150,
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
                    width: widget.deviceSize.width * 0.8,
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
                                    tag: 'image' + itemIndex.toString(),
                                    transitionOnUserGestures: true,
                                  ),
                                  imageProvider: NetworkImage(
                                      widget.imagesURLs[itemIndex]),
                                ),
                              ),
                            );
                          },
                          fullscreenDialog: true,
                        ));
                      },
                      child: Hero(
                        tag: 'image' + itemIndex.toString(),
                        child: Image.network(widget.imagesURLs[itemIndex]),
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                width: widget.deviceSize.width * 0.7,
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
                                tag: 'image',
                                transitionOnUserGestures: true,
                              ),
                              imageProvider: NetworkImage(widget.imagesURLs[0]),
                            ),
                          ),
                        );
                      },
                      fullscreenDialog: true,
                    ));
                  },
                  child: Hero(
                    tag: 'image',
                    child: Image.network(widget.imagesURLs[0]),
                  ),
                ),
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

class ModalBottmSheet extends StatefulWidget {
  @override
  _ModalBottmSheetState createState() => _ModalBottmSheetState();
}

class _ModalBottmSheetState extends State<ModalBottmSheet> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
