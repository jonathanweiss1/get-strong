// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

/// This file contains global constants which are used throughout the application.

/// Skip auth, for example in case there is no internet connection during development
const bool DEBUG_SKIP_AUTH = false;

/// Theme colors
const Color GSPrimaryColor = Color(0xFF26D1FE);
const Color GSTextColor = Color(0xFF333333);
const Color GSTextSecondaryColor = Color(0xFF666666);
const Color GSTextTernaryColor = Color(0xFF999999);
const Color GSHighlightColor = Color(0xFFFF527A);
const LinearGradient GSPrimaryGradient =
    LinearGradient(colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)]);
const LinearGradient GSHighlightGradient =
    LinearGradient(colors: [Color(0xFFFF527A), Color(0xFFFF9575)]);
const LinearGradient GSSecondaryGradient =
    LinearGradient(colors: [Color(0xFF19D191), Color(0xFF39FB90)]);
