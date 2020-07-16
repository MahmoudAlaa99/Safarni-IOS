import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safarni/View_Models/UserProfileViewModel.dart';

class UserProfileCard extends StatefulWidget {
  final deviceSize;
  final i;
  UserProfileCard({this.deviceSize, this.i});
  @override
  _UserProfileCardState createState() => _UserProfileCardState();
}

class _UserProfileCardState extends State<UserProfileCard> {
  @override
  Widget build(BuildContext context) {
    final userProfileViewModel =
        Provider.of<UserProfileViewModel>(context, listen: false);
    return Column(
      children: <Widget>[
        ListTile(
          leading: Container(
            height: widget.deviceSize.height * 0.08,
            width: widget.deviceSize.height * 0.08,
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(
              widget.deviceSize.width * 0.05,
              widget.deviceSize.height * 0.0,
              widget.deviceSize.width * 0.05,
              widget.deviceSize.height * 0.0,
            ),
            child: CircleAvatar(
              radius: widget.deviceSize.height * 0.04,
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: NetworkImage(
                userProfileViewModel.displayPicture,
              ),
            ),
          ),
          trailing: userProfileViewModel.isSelf
              ? Container()
              : Container(
                  width: widget.deviceSize.width * 0.22,
                  height: widget.deviceSize.height * 0.08,
                  padding: EdgeInsets.symmetric(
                      vertical: widget.deviceSize.height * 0.02),
                  child: Consumer<UserProfileViewModel>(
                    builder: (ctx, userProfileViewModel, _) =>
                        FloatingActionButton(
                      heroTag: 'FollowButton' + widget.i.toString(),
                      backgroundColor: userProfileViewModel.isFollowing
                          ? Theme.of(context).accentColor
                          : Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: widget.deviceSize.width * 0.01,
                          ),
                          Icon(
                            Icons.person_add,
                            size: widget.deviceSize.width * 0.04,
                            color: userProfileViewModel.isFollowing
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).accentColor,
                          ),
                          Text(
                            userProfileViewModel.isFollowing
                                ? 'Unfollow'
                                : ' Follow',
                            style: TextStyle(
                              color: userProfileViewModel.isFollowing
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).accentColor,
                              fontSize: widget.deviceSize.width * 0.035,
                            ),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        await userProfileViewModel
                            .toggleFollow(!userProfileViewModel.isFollowing);
                      },
                    ),
                  ),
                ),
          subtitle: Container(
            width: widget.deviceSize.width * 0.45,
            child: Text(
              userProfileViewModel.userName,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: widget.deviceSize.width * 0.035,
                color: Colors.black54,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          title: Container(
            width: widget.deviceSize.width * 0.44,
            margin: EdgeInsets.only(right: widget.deviceSize.width * 0.05),
            child: Text(
              userProfileViewModel.firstName +
                  ' ' +
                  userProfileViewModel.lastName,
              maxLines: 1,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: widget.deviceSize.width * 0.042,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          //elevation: 5,
          //color: Theme.of(context).accentColor,
        ),
        Divider(color: Colors.black38, height: 1, thickness: 0.3)
      ],
    );
  }
}
