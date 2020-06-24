import 'package:photocontrolapp/models/models.dart';

class ViolationsRepository {
  Future saveViolations(List<Violation> list) async {}

  Future<List<Violation>> loadViolations() async {
    //TODO Save

    return [
      Violation(title: "Беды с водой", images: [
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.ytimg.com%2Fvi%2FDt8y0l-n7ig%2Fmaxresdefault.jpg&f=1&nofb=1"
      ]),
      Violation(title: "Заглушка не работает", images: [
        "https://external-content.duckduckgo.com/iu/?u=http%3A%2F%2Fmd-eksperiment.org%2Fimages%2Fposters%2F55154130cb1a7.jpg&f=1&nofb=1"
      ]),
      Violation(title: "Ржавчина на трубопроводе", images: [
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftokar.guru%2Fimages%2F328555%2Fproizvesti_vrezku_truboprovod.jpg&f=1&nofb=1"
      ]),
      Violation(title: "Неверный угол входа в воду", images: [
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fpolit.ru%2Fmedia%2Fphotolib%2F2015%2F05%2F26%2Fthumbs%2Ftruba_1560610395.jpg.600x450_q85.jpg&f=1&nofb=1"
      ]),
      Violation(title: "Трубопровод", images: [
        "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Ftrubadelo.ru%2Fwp-content%2Fuploads%2F2017%2F09%2Fpolietilenovyj-truboprovod.jpg&f=1&nofb=1"
      ]),
    ];
  }
}
