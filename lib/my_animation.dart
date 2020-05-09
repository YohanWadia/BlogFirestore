
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';


class AnimateMiniLike extends StatefulWidget {
  int likeCounter;
  AnimateMiniLike(this.likeCounter);
  AnimateMiniLikeState createState() => AnimateMiniLikeState();
}


class AnimateMiniLikeState extends State<AnimateMiniLike> with TickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _animation;

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {

    return ScaleTransition(
        scale: _animation,
        alignment: Alignment.center,
        child:Container(
            decoration: new BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  new BoxShadow(
                    blurRadius: 3.0,
                    offset: const Offset(3.0, 0.0),
                    color: Colors.grey,
                  )
                ]
            ),
            child: Row( mainAxisSize: MainAxisSize.min,
              children: [
                new Icon(Icons.thumb_up, size: 20.0, color:Colors.blue),
                SizedBox(width:5),
                Text('${widget.likeCounter}',style: TextStyle(fontSize: 18),),
                SizedBox(width:5),
              ],)
        )

    );
  }
}

