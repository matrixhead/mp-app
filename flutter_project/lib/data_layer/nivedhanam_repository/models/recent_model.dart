import 'package:equatable/equatable.dart';
import 'package:mpapp/data_layer/nivedhanam_repository/nivedhanam_repository.dart';

const int MAX = 15;

class Recent extends Equatable {
  final List<Nivedhanam> recentNivedhanams;

  const Recent(this.recentNivedhanams);

  Recent addNivedhanam(Nivedhanam n) {
    final List<Nivedhanam> current = List.from(recentNivedhanams)
      ..removeWhere((element) => element == n);
    current.insert(0, n);
    if (current.length > MAX) {
      current.removeLast();
    }
    return Recent(current);
  }

  @override
  List<Object?> get props => [recentNivedhanams];
}
