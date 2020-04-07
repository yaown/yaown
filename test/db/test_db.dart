import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yaown/dbutils/category_provider.dart';
import 'package:yaown/dbutils/interfaces/exceptions.dart';

void main() {

  TestWidgetsFlutterBinding.ensureInitialized();

  group("Test 📌: CategoryProvider", () {

    var dir = getApplicationDocumentsDirectory();
    var file = Future(() => dir).then((dir) =>
        File(join(dir.path, CategoryProvider().file))
    );

    /// Helper to properly initialize an empty database
    setUp() async {
      var f = await file;
      if(await f.exists())
        await f.delete();
      await CategoryProvider().init();
    }

    /// Helper to properly tear down an existing database
    tearDown() async {
      var f = await file;
      await CategoryProvider().clear();
      await CategoryProvider().close();
      if(await f.exists())
        await f.delete();
    }

    /// Async test wrapper
    testAsync(String description, Function function) async {
      testWidgets(description, (WidgetTester tester) async {
        await tester.runAsync(() async {
          await setUp();
          await function();
          await tearDown();
        });
      });
    }


    testAsync("=> initialization 📐", () async {
      expect(await (await file).exists(), isTrue);
      expect((await CategoryProvider().getAll()).length, 0);
    });


    testAsync("=> destruction 💥", () async {
      Category category1 = await CategoryProvider().newRecord(name: "test1");
      await CategoryProvider().close();
      expect(category1.immutable, isTrue);
      Category category2 = await CategoryProvider().get(0);
      expect(category1.name, category2.name);
      expect(identical(category1, category2), isFalse);
    });


    testAsync("=> id generator 🎫", () async {
      expect((await CategoryProvider().newRecord()).id, 0);
      expect((await CategoryProvider().newRecord()).id, 1);
      expect((await CategoryProvider().newRecord()).id, 2);

      // freed the id 1
      await CategoryProvider().removeById(1);

      // should automatically pic the 1
      // because its the smallest free id
      expect((await CategoryProvider().newRecord()).id, 1);
    });


    testAsync("=> db persisence 🖇‍", () async {
      var parentBefore = await CategoryProvider().newRecord(
        name: "parent",
      );
      var childBefore = await CategoryProvider().newRecord(
        name: "child",
        parent: 0
      );

      await CategoryProvider().close();

      Category parent = await CategoryProvider().get(0);
      Category child = await CategoryProvider().get(1);

      // after closing and reopening
      // the records should be the same
      expect(childBefore == child, isTrue);
      expect(child.parent, parent.id);
    });


    testAsync("=> deletion ⚡️", () async {
      var parent = await CategoryProvider().newRecord();
      var child = await CategoryProvider().newRecord(parent: parent.id);

      await parent.destroy();

      // trying to set any field of a
      // destroyed record should throw
      // exceptions
      expect(() async => await parent.setName(""),
          throwsA(isInstanceOf<RecordIsImmutable>()));
      expect(() async => await parent.setParent(0),
          throwsA(isInstanceOf<RecordIsImmutable>()));

      // after deleting the parent
      // the child should not have any parent
      expect(child.parent, isNull);
    });


  });
}