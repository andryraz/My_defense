// create a function that check with provider if user connected is admin or not
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';

bool isAdmin(BuildContext context) {
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  UserModel? user = userProvider.user ?? null;

  return user != null && user.role == 'admin';
}

bool isStudent(BuildContext context) {
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  UserModel? user = userProvider.user ?? null;

  return user != null && user.role == 'student';
}

bool isTeacher(BuildContext context) {
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
  UserModel? user = userProvider.user ?? null;

  return user != null && ["president", "rapporteur", "examinateur"].contains(user.role);
}
