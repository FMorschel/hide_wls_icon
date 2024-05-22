import 'dart:convert';
import 'dart:io';

import 'package:hide_wls_icon/message.dart';
import 'package:win32_registry/win32_registry.dart';

void main(List<String> arguments) async {
  const keyPath = r'Software\Microsoft\Windows\CurrentVersion'
      r'\Explorer\HideDesktopIcons\NewStartPanel';

  const value = RegistryValue(
    '{B2B4A4D1-2754-4140-A2EB-9A76D9D7CDC6}',
    RegistryValueType.int32,
    1,
  );

  print('Starting...');

  MessageBox? msg;
  try {
    msg = MessageBox();
  } catch (e) {
    print('Error: $e');
  }

  final result = await Process.run('net', ['session']);
  final notADM = result.exitCode != 0;

  print('Running as administrator: ${!notADM}');

  print('Getting key: $keyPath');
  try {
    final key = Registry.openPath(
      notADM ? RegistryHive.currentUser : RegistryHive.allUsers,
      path: keyPath,
      desiredAccessRights: AccessRights.writeOnly,
    );

    print('Setting value: $value');
    key.createValue(value);

    msg?.show(
      title: 'Success!',
      text: 'Please refresh your desktop to see the changes.',
    );

    print('Success! Please refresh your desktop to see the changes.');
    print('\nDone.');

    print('\nYou can close this window now.');
  } catch (e) {
    msg?.show(title: 'Error', text: 'Error: $e');
    print('Error: $e');
  } finally {
    // Pause the program
    final process = await Process.start('cmd', ['/c', 'pause']);

    process.stdout.transform(utf8.decoder).listen(print);
    process.stderr.transform(utf8.decoder).listen(print);

    process.stdin.add(utf8.encoder.convert(stdin.readLineSync() ?? ''));

    await process.exitCode;
  }
}
