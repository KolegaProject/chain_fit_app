import 'package:chain_fit_app/features/dashboard/model/user_model.dart';

class Registrant {
  final int id;
  final String username;
  final String email;

  Registrant({
    required this.id,
    required this.username,
    required this.email,
  });

  factory Registrant.fromAppUser(AppUser user) {
    return Registrant(
      id: user.id,
      username: user.username,
      email: user.email,
    );
  }
}
