import 'package:equatable/equatable.dart';

class CurrentUser extends Equatable {
  final String id;
  final int publicid;
  final String displayName;
  final String username;
  final bool isPrivate;
  final bool isVerified;
  final bool privateMail;

  const CurrentUser({
    required this.id,
    required this.publicid,
    required this.displayName,
    required this.username,
    required this.isPrivate,
    required this.isVerified,
    required this.privateMail,
  });

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      id: json['_id'] as String,
      publicid: json['publicid'] as int,
      username: json['username'] as String,
      displayName: json['displayname'] as String,
      isPrivate: json['isprivate'] as bool,
      isVerified: json['isverified'] as bool,
      privateMail: json['privatemail'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'publicid': publicid,
      'username': username,
      'displayname': displayName,
      'isprivate': isPrivate,
      'isverified': isVerified,
      'privatemail': privateMail,
    };
  }

  @override
  List<Object?> get props => [id, publicid, displayName, username, isPrivate, isVerified, privateMail];

  CurrentUser copyWith({String? id, int? publicid, String? displayName, String? username, bool? isPrivate, bool? isVerified, bool? privateMail}) {
    return CurrentUser(
      id: id ?? this.id,
      publicid: publicid ?? this.publicid,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      isPrivate: isPrivate ?? this.isPrivate,
      isVerified: isVerified ?? this.isVerified,
      privateMail: privateMail ?? this.privateMail,
    );
  }
}
