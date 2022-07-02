class TestAttachment {
  final int id;

  TestAttachment({required this.id});

  factory TestAttachment.fromJson(Map<String, dynamic> json) {
    return TestAttachment(id: json['attachment_id']==null?0: int.parse(json['attachment_id']));
  }

  Map<String, dynamic> get asJson => {
        'attachment_id': id,
      };
}
