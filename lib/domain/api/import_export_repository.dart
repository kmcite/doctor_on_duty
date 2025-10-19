import 'dart:io';

/// Import data from a file system into application data
class ImportRepository<T> {
  Future<T> import(File file) async {
    // TODO: read file and convert to T
    throw UnimplementedError();
  }
}

/// Export application data to the file system
class ExportRepository<T> {
  Future<File> export(T data, String path) async {
    // TODO: convert data to file and save at path
    throw UnimplementedError();
  }
}

/// IMPLEMENTATIONS
