class FictionDetailPageModelEntity {
	List<FictionDetailPageModelFiction> fictions;
	FictionDetailPageModelLastchapter lastChapter;
	List<FictionDetailPageModelFiction> sameTypeFictions;

	FictionDetailPageModelEntity({this.fictions, this.lastChapter, this.sameTypeFictions});

	FictionDetailPageModelEntity.fromJson(Map<String, dynamic> json) {
		if (json['ficitons'] != null) {
			fictions = new List<FictionDetailPageModelFiction>();(json['ficitons'] as List).forEach((v) { fictions.add(new FictionDetailPageModelFiction.fromJson(v)); });
		}
		lastChapter = json['lastChapter'] != null ? new FictionDetailPageModelLastchapter.fromJson(json['lastChapter']) : null;
		if (json['sameTypeFictions'] != null) {
			sameTypeFictions = new List<FictionDetailPageModelFiction>();(json['sameTypeFictions'] as List).forEach((v) { sameTypeFictions.add(new FictionDetailPageModelFiction.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.fictions != null) {
      data['ficitons'] =  this.fictions.map((v) => v.toJson()).toList();
    }
		if (this.lastChapter != null) {
      data['lastChapter'] = this.lastChapter.toJson();
    }
		if (this.sameTypeFictions != null) {
      data['sameTypeFictions'] =  this.sameTypeFictions.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class FictionDetailPageModelFiction {
	String fictionDesc;
	String fictiontype;
	String author;
	String fictionName;
	int id;

	FictionDetailPageModelFiction({this.fictionDesc, this.fictiontype, this.author, this.fictionName, this.id});

	FictionDetailPageModelFiction.fromJson(Map<String, dynamic> json) {
		fictionDesc = json['fictionDesc'];
		fictiontype = json['fictiontype'];
		author = json['author'];
		fictionName = json['fictionName'];
		id = json['id'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['fictionDesc'] = this.fictionDesc;
		data['fictiontype'] = this.fictiontype;
		data['author'] = this.author;
		data['fictionName'] = this.fictionName;
		data['id'] = this.id;
		return data;
	}
}

class FictionDetailPageModelLastchapter {
	int chapterId;
	String ctime;
	int fictionId;
	int id;
	String title;

	FictionDetailPageModelLastchapter({this.chapterId, this.ctime, this.fictionId, this.id, this.title});

	FictionDetailPageModelLastchapter.fromJson(Map<String, dynamic> json) {
		chapterId = json['chapterId'];
		ctime = json['ctime'];
		fictionId = json['fictionId'];
		id = json['id'];
		title = json['title'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['chapterId'] = this.chapterId;
		data['ctime'] = this.ctime;
		data['fictionId'] = this.fictionId;
		data['id'] = this.id;
		data['title'] = this.title;
		return data;
	}
}


