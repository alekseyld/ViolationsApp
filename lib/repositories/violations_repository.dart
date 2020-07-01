import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photocontrolapp/models/models.dart';

class ViolationsRepository {
  Future<String> get _localPath async {
    return join(
      (await getApplicationSupportDirectory()).path,
      'violations.json',
    );
  }

  Future<File> get _localFile async {
    return File(await _localPath);
  }

  Future saveViolations(List<Violation> list) async {
    File file = await _localFile;

    final isExist = await file.exists();
    if (!isExist) {
      file = await file.create();
    }

    String json = jsonEncode(list);

    await file.writeAsString(json);
  }

  Future<List<Violation>> loadViolations() async {
    final file = await _localFile;

    String jsonString;
    try {
      jsonString = await file.readAsString();

      List l = json.decode(jsonString);
      List<Violation> violations = l.map((dynamic model) {
        return Violation.fromJson(model);
      }).toList();

      return violations;
    } catch (e, s) {
      print("Exception $e");
      print("Stacktrace $s");
      return [];
    }
  }
}
