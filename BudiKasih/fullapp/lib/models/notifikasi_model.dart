// lib/models/notifikasi_model.dart

import 'package:flutter/material.dart';

class NotificationSection {
  final String date;
  final List<NotificationModel> items;

  NotificationSection({
    required this.date,
    required this.items,
  });
}

class NotificationModel {
  final String msg;
  final bool isRead;
  final IconData icon;
  final Color iconColor;
  final String type;
  final String detail;

  NotificationModel({
    required this.msg,
    required this.isRead,
    required this.icon,
    required this.iconColor,
    required this.type,
    required this.detail,
  });

  NotificationModel copyWith({
    String? msg,
    bool? isRead,
    IconData? icon,
    Color? iconColor,
    String? type,
    String? detail,
  }) {
    return NotificationModel(
      msg: msg ?? this.msg,
      isRead: isRead ?? this.isRead,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      type: type ?? this.type,
      detail: detail ?? this.detail,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'isRead': isRead,
      'type': type,
      'detail': detail,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    IconData icon;
    Color iconColor;

    // Map type to icon
    switch (json['type']) {
      case 'donation':
        icon = Icons.volunteer_activism;
        iconColor = Colors.green;
        break;
      case 'info':
        icon = Icons.info_outline;
        iconColor = Colors.blue;
        break;
      case 'event':
        icon = Icons.event;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.notifications;
        iconColor = Colors.grey;
    }

    return NotificationModel(
      msg: json['msg'] ?? '',
      isRead: json['isRead'] ?? false,
      icon: icon,
      iconColor: iconColor,
      type: json['type'] ?? 'info',
      detail: json['detail'] ?? '',
    );
  }
}