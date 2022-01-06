import 'package:test_rail/test_attachment.dart';
import 'package:test_rail/src/test_rail_http_client.dart';
import 'package:test_rail/test_rail.dart';

class TestResult {
  final int? assignedToId;

  /// Not provided as response field in TestRail API documentation
  final List<int>? attachmentIds;
  final String? comment;
  final int? createdBy;
  final DateTime? createdOn;
  final List<CustomStep>? customStepResults;
  final String? defects;

  /// in `1m 38s` format
  final String? elapsed;
  final int id;
  final int? statusId;
  final int? testId;
  final String? version;

  TestResult({
    this.assignedToId,
    this.attachmentIds,
    this.comment,
    this.createdBy,
    this.createdOn,
    this.customStepResults,
    this.defects,
    this.elapsed,
    required this.id,
    this.statusId,
    this.testId,
    this.version,
  });

  factory TestResult.fromJson(Map<String, dynamic> json) {
    DateTime? createdOn;

    if (json['created_on'] != null) {
      createdOn = DateTime.fromMillisecondsSinceEpoch(json['created_on']);
    }

    List<CustomStep>? customStepsSeparated;

    if (json['custom_steps_results'] != null) {
      customStepsSeparated = List.from(
        json['custom_steps_results'].map(
          (stepJson) => CustomStep.fromJson(stepJson),
        ),
      );
    }

    return TestResult(
      assignedToId: json['assignedto_ids'],
      attachmentIds: List<int>.from(json['attachment_ids']),
      comment: json['comment'],
      createdBy: json['created_by'],
      createdOn: createdOn,
      customStepResults: customStepsSeparated,
      defects: json['defects'],
      elapsed: json['elapsed'],
      id: json['id'],
      statusId: json['status_id'],
      testId: json['test_id'],
      version: json['version'],
    );
  }

  Future<TestAttachment> addAttachment(String path) async {
    final url = '/add_attachment_to_result/$id';
    final response = await TestRail.instance.client
        .request(url, RequestMethod.postMultipart, params: {'filePath': path});
    return TestAttachment.fromJson(response);
  }

  Map<String, dynamic> get asJson => {
        'assignedto_id': assignedToId,
        'attachment_ids': attachmentIds,
        'comment': comment,
        'created_by': createdBy,
        'created_on': createdOn?.millisecondsSinceEpoch,
        'custom_step_results': customStepResults?.map((v) => v.asJson).toList(),
        'defects': defects,
        'elapsed': elapsed,
        'id': id,
        'status_id': statusId,
        'test_id': testId,
        'version': version,
      };
}

class CustomStep {
  final String? actual;
  final String? content;
  final String? expected;
  final int? statusId;

  CustomStep({
    this.actual,
    this.content,
    this.expected,
    this.statusId,
  });

  factory CustomStep.fromJson(Map<String, dynamic> json) {
    return CustomStep(
      actual: json['actual'],
      content: json['content'],
      expected: json['expected'],
      statusId: json['status_id'],
    );
  }

  Map<String, dynamic> get asJson => {
        'actual': actual,
        'content': content,
        'expected': expected,
        'status_id': statusId,
      };
}
