import 'dart:io';

String fixture(String name) => File('test/mock/$name').readAsStringSync();
