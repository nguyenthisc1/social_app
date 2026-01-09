import 'dart:convert';
import 'dart:io';

/// Read JSON fixture files for testing
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

/// Parse JSON fixture
Map<String, dynamic> fixtureJson(String name) =>
    json.decode(fixture(name)) as Map<String, dynamic>;

/// Parse JSON fixture as list
List<dynamic> fixtureJsonList(String name) =>
    json.decode(fixture(name)) as List<dynamic>;

