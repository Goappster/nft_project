import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user.dart';

class UserCubit extends Cubit<User?> {
  UserCubit(User? user) : super(user);

  void setUser(User user) => emit(user);
  void clearUser() => emit(null);
}
