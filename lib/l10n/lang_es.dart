import 'lang.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LangEs extends Lang {
  LangEs([String locale = 'es']) : super(locale);

  @override
  String get gLoading => 'Cargando';

  @override
  String get gSettingsHint => 'Abrir la página de configuración';
}
