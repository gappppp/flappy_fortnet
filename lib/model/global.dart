class Global {
  //private constructor
  Global._internal();

  //singleton
  static final Global _instance = Global._internal();

  //public: get instance
  factory Global() => _instance;

  //private fields
  String _preferedLanguage = "json";
  String _token = "";

  // _preferedLanguage fns
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

  //_token fns
  String getToken() {
    return _token;
  }

  bool isTokenValid() {
    //todo
    return _token != "";
  }

  void setToken(String token) {
    _token = token;
  }

  void logout() {
    _token = "";
  }
}