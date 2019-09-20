class ChapterListModel {
  List<ChapterInfo> chapterInfos;


  ChapterListModel({this.chapterInfos});

  ChapterListModel.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      chapterInfos = new List<ChapterInfo>();
      (json as List).forEach((v) { chapterInfos.add(new ChapterInfo.fromJson(v)); });
    }
  }

  List< dynamic>  toJson() {
    final List< dynamic> data = new List();
    if (this.chapterInfos != null) {
      data.addAll(this.chapterInfos.map((v) => v.toJson()).toList());
    }
    return data;
  }
}


class ChapterInfo {
  String title;
  int id;
  int fictionId;
  String ctime;
  int words;
  int contentId;
  int chapterId;

  ChapterInfo({this.chapterId, this.contentId, this.words, this.ctime, this.fictionId,this.id,this.title});

  ChapterInfo.fromJson(Map<String, dynamic> json) {
    chapterId = json['chapterId'];
    contentId = json['contentId'];
    words = json['words'];
    ctime = json['ctime'];
    id = json['id'];
    fictionId = json['fictionId'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chapterId'] = this.chapterId;
    data['contentId'] = this.contentId;
    data['words'] = this.words;
    data['ctime'] = this.ctime;
    data['fictionId'] = this.fictionId;
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
  }
}