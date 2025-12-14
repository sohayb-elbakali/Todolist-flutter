import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:todolist_app/firebase_options.dart';
import 'package:todolist_app/application.dart';

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	await Firebase.initializeApp(
		options: DefaultFirebaseOptions.currentPlatform,
	);

	runApp(const MyApp());
}
