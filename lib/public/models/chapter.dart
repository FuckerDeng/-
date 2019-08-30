class Chapter {
	int contentId;
	int chapterId;
	List<String> rows;
	String title;
	String content;
	List<String> pageStrs;

	Chapter({this.contentId, this.chapterId, this.rows, this.title, this.content});

	Chapter.fromJson(Map<String, dynamic> json) {
		contentId = json['content_id'];
		chapterId = json['chapter_Id'];
		rows = json['rows']?.cast<String>();
		title = json['title'];
		content = json['content'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['content_id'] = this.contentId;
		data['chapter_Id'] = this.chapterId;
		data['rows'] = this.rows;
		data['title'] = this.title;
		data['content'] = this.content;
		return data;
	}
}
