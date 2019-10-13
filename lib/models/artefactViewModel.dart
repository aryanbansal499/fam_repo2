import 'package:flutter/foundation.dart';

class ArtefactViewModel extends ChangeNotifier {
  final viewType currView;
  final String matchId;

  ArtefactViewModel(this.currView, this.matchId);

}

enum viewType {family, uploader, singular}

