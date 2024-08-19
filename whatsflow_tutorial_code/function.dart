import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/flutter_flow/custom_functions.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

List<DocumentReference>? addItemAtTopOfList(
  List<DocumentReference>? listOfUsers,
  DocumentReference? user,
) {
  /// MODIFY CODE ONLY BELOW THIS LINE

  // add user document reference at the top of the listOfUsers document references
  if (user != null) {
    if (listOfUsers == null) {
      listOfUsers = [user];
    } else {
      listOfUsers.insert(0, user);
    }
  }
  return listOfUsers;

  /// MODIFY CODE ONLY ABOVE THIS LINE
}