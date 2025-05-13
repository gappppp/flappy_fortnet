class Global {
  //private constructor
  Global._internal();

  //singleton
  static final Global _instance = Global._internal();

  //public: get instance
  factory Global() => _instance;

  //private fields
  String _preferedLanguage = "json";

  String getPreferedLanguage() {
    return _preferedLanguage;
  }

  void changePreferedLanguage() {
    if (_preferedLanguage == "json") {
      _preferedLanguage = "xml";
    } else {
      _preferedLanguage = "json";
    }
  }
}