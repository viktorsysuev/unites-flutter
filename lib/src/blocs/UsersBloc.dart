import 'package:rxdart/rxdart.dart';
import 'package:unites_flutter/src/models/UserModel.dart';
import 'package:unites_flutter/src/resources/UserRepository.dart';

class UsersBloc {
  final _userRepository = UserRepository();
  final _userFetcher = PublishSubject<UserModel>();

  Stream<UserModel> get getUser => _userFetcher.stream;

  fetchCurrentUser() async {
    var userId = await _userRepository.getCurrentUserId();
    UserModel user = await _userRepository.getUser(userId);
    _userFetcher.sink.add(user);
  }

  dispose() {
    _userFetcher.close();
  }
}
