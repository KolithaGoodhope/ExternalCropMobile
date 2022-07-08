class User{
  int USR_ID = 0 ;
  String USR_USER_NAME = "" ;
  String USR_PASSWORD = "" ;
  int USER_ROLE_ID = 0;

  User({
     this.USR_ID,
     this.USR_USER_NAME,
     this.USR_PASSWORD,
     this.USER_ROLE_ID,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      USR_ID: json['USR_ID'],
      USR_USER_NAME: json['USR_USER_NAME'],
      USR_PASSWORD: json['USR_PASSWORD'],
      USER_ROLE_ID: json['USER_ROLE_ID'],
    );
  }
  Map<String, dynamic> toMap() => {
    "USR_ID": USR_ID,
    "USR_USER_NAME": USR_USER_NAME,//ID,
    "USR_PASSWORD": USR_PASSWORD,//enPassword,
    "USER_ROLE_ID":USER_ROLE_ID,
  };

}