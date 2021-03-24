
class User{
  String _userName;
  String _email;
  String _id;
  User(this._id , this._userName ,this._email);
  User.empty();


  void setUser(User user){
    _id = user._id;
    _userName = user._userName;
    _email = user._email;
  }
}