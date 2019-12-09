part of '../super_infinite_listview.dart';

class SuperInfiniteListView extends StatefulWidget {
  SuperInfiniteListView({ Key key, @required this.onRequest, @required this.itemBuilder, this.delay, this.emptyWidget, this.loadingWidget }) : super(key: key);
  
  final num delay;
  final onRequest;
  final itemBuilder;
  final Widget emptyWidget;
  final Widget loadingWidget;

  @override
  _SuperInfiniteListViewState createState() => new _SuperInfiniteListViewState();
}

class _SuperInfiniteListViewState extends State<SuperInfiniteListView> {
  _SuperInfiniteListViewState({Key key});
  
  static const loadingTag = "##loading##"; //表尾标记
  bool init = true;
  num _total = 0;
  List _words = [loadingTag];

  @override
  void initState() {
    super.initState();
    
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: _words.length,
      // itemExtent: 50,
      //列表项构造器
      itemBuilder: (context, index) {
        //如果到了表尾
        if (_words[index] == loadingTag) {
          if (init) {
            //加载时显示loading
            return widget.loadingWidget != null ? widget.loadingWidget : Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0)),
            );
          }

          //不足100条，继续获取数据
          if (_words.length - 1 < _total) {
            //获取数据
            _retrieveData();
            //加载时显示loading
            return widget.loadingWidget != null ? widget.loadingWidget : Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(strokeWidth: 2.0)),
            );
          } else {
            //已经加载了100条数据，不再获取数据。
            return widget.emptyWidget != null ? widget.emptyWidget : Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "没有更多了",
                  style: TextStyle(color: Colors.grey),
                ));
          }
        }
        //显示单词列表项
        return widget.itemBuilder(_words[index], index, _words);
      },
      //分割器构造器
      separatorBuilder: (context, index) => Divider(height: .0),
    );
  }

  Future _retrieveData() async {
    var listMap = await widget.onRequest();
    var list = listMap["list"];
    _total = listMap["totalNumber"];

    if (list.length > 0) {
      Future.delayed(Duration(seconds: widget.delay != null ? widget.delay : 1)).then((e) {
        _words.insertAll( _words.length - 1, list);

        setState(() {
          //重新构建列表
          if (init == true) init = false;
        });
      });
    }
  }
}
