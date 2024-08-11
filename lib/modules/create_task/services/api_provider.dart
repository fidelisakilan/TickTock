import 'dart:convert';
import 'dart:developer';
import 'package:tick_tock/app/models/task_details_model.dart';
import 'package:tick_tock/modules/create_task/models/extensions.dart';
import 'package:tick_tock/shared/core/network/api_response.dart';
import 'package:tick_tock/shared/core/network/network_requester.dart';

class ApiProvider {
  Future<TaskDetails?> fetchPromptData(String content) async {
    try {
      final response = await NetworkRequester.instance.post(
        path: '/process_text',
        data: {
          "text": content,
          "timestamp": DateTime.now().toIso8601String(),
        },
      );
      if (response is APIResponse) {
        Map<String, dynamic> jsonData = jsonDecode(response.data);
        jsonData.addEntries([
          const MapEntry('runtimeType', 'default'),
          MapEntry('id', Utils.randomInt),
        ]);
        final result = TaskDetails.fromJson(jsonData);
        return result;
      }
    } catch (e, stack) {
      log('prompt_response', error: e, stackTrace: stack);
    }
    return null;
  }
}
