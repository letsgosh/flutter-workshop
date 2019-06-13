import 'dart:async';

import 'package:flutter/material.dart';
import 'notice.dart';
import '../conection/api.dart';

class ContentNewsPage extends StatefulWidget {
  final vsync;

  var errorConection = false;

  ContentNewsPage(this.vsync);

  final state = new _ContentNewsPageState();

  @override
  _ContentNewsPageState createState() => state;
}

class _ContentNewsPageState extends State<ContentNewsPage> {
  List _news = new List();
  var carregando = false;
  var repository = new NewsApi();
  var page = 0;
  var pages = 1;

  @override
  void initState() {
    loadCategory(page);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(current_category);

    return new Container(
        child: new Column(
      children: <Widget>[
        widget.errorConection
            ? _buildConnectionError()
            : new Expanded(child: _getListViewWidget())
      ],
    ));
  }

  Widget _buildConnectionError() {
    return new Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 8.0,
      ),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.cloud_off,
              size: 100.0,
              color: Colors.blue,
            ),
            new Text(
              "Erro de conexão",
              style: TextStyle(
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: new RaisedButton(
                onPressed: () {
                  loadCategory(page);
                },
                child: new Text("TENTAR NOVAMENTE"),
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getListViewWidget() {
    ListView listView = new ListView.builder(
        itemCount: _news.length,
        padding: new EdgeInsets.only(top: 5.0),
        itemBuilder: (context, index) {
          //final Map notice = _news[index];
          //print(index);

          if (index >= _news.length - 4 && !carregando) {
            loadCategory(page);
          }

          return _news[index];
        });

    RefreshIndicator refreshIndicator =
        new RefreshIndicator(onRefresh: myRefresh, child: listView);

    return new Stack(
      children: <Widget>[refreshIndicator, _getProgress()],
    );
  }

  Widget _getProgress() {
    if (carregando) {
      return new Container(
        child: new Center(
          child: new CircularProgressIndicator(),
        ),
      );
    } else {
      return new Container();
    }
  }

  Future<Null> myRefresh() async {
    await loadCategory(page);

    return null;
  }

  loadCategory(page) async {
    if (page < pages - 1 || page == 0) {
      setState(() {
        if (page == 0) {
          _news.clear();
        }

        carregando = true;
      });

      Map result = await repository.loadNews(page.toString());

      if (result != null) {
        widget.errorConection = false;

        setState(() {
          pages = result['data']['pages'];
          this.page = page + 1;
          result['data']['news'].forEach((item) {
            var notice = new Notice(
                item['url_img'] == null ? '' : item['url_img'],
                item['tittle'] == null ? '' : item['tittle'],
                item['date'] == null ? '' : item['date'],
                item['description'] == null ? '' : item['description'],
                item['category'] == null ? '' : item['category'],
                item['link'] == null ? '' : item['link'],
                item['origin'] == null ? '' : item['origin'],
                new AnimationController(
                  duration: new Duration(milliseconds: 300),
                  vsync: widget.vsync,
                ));
            _news.add(notice);
            notice.animationController.forward();
          });

          carregando = false;
        });
      } else {
        widget.errorConection = true;

        setState(() {
          carregando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    for (Notice n in _news) n.animationController.dispose();
    super.dispose();
  }
}
