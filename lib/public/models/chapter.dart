class Chapter{
	int contentId;
	int chapterId;
	String title;
	String content;


	Chapter({this.contentId, this.chapterId, this.title, this.content});

	Chapter.fromJson(Map<String, dynamic> json) {
		contentId = json['content_id'];
		chapterId = json['chapterId'];
		title = json['title'];
		content = json['content'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['content_id'] = this.contentId;
		data['chapterId'] = this.chapterId;
		data['title'] = this.title;
		data['content'] = this.content;
		return data;
	}
}
