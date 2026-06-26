import 'package:flutter/material.dart';

class Schedule {
  String id;
  String courseId;
  String teacherId;
  String dayOfWeek; // "Monday", "Tuesday", ...
  TimeOfDay startTime;
  TimeOfDay endTime;
  String room;

  Schedule({
    required this.id,
    required this.courseId,
    required this.teacherId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
  });

  // Pour stocker TimeOfDay en JSON, on utilise des strings "HH:mm"
  Map<String, dynamic> toMap() {
    // Convertir TimeOfDay en String "HH:mm"
    String startStr = _timeOfDayToString(startTime);
    String endStr = _timeOfDayToString(endTime);
    
    return {
      'id': id,
      'courseId': courseId,
      'teacherId': teacherId,
      'dayOfWeek': dayOfWeek,
      'startTime': startStr,
      'endTime': endStr,
      'room': room,
    };
  }

  // Méthode utilitaire pour convertir TimeOfDay en String
  String _timeOfDayToString(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Méthode utilitaire pour convertir String en TimeOfDay
  TimeOfDay _stringToTimeOfDay(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    // On reconstruit TimeOfDay depuis "HH:mm"
    List<String> startParts = map['startTime'].split(':');
    List<String> endParts = map['endTime'].split(':');
    
    return Schedule(
      id: map['id'],
      courseId: map['courseId'],
      teacherId: map['teacherId'],
      dayOfWeek: map['dayOfWeek'],
      startTime: TimeOfDay(
        hour: int.parse(startParts[0]), 
        minute: int.parse(startParts[1])
      ),
      endTime: TimeOfDay(
        hour: int.parse(endParts[0]), 
        minute: int.parse(endParts[1])
      ),
      room: map['room'],
    );
  }

  // Méthode pour afficher l'heure au format lisible
  String get startTimeFormatted => _timeOfDayToString(startTime);
  String get endTimeFormatted => _timeOfDayToString(endTime);
  
  // Méthode pour obtenir une représentation lisible du jour
  String get dayOfWeekFr {
    const days = {
      'Monday': 'Lundi',
      'Tuesday': 'Mardi',
      'Wednesday': 'Mercredi',
      'Thursday': 'Jeudi',
      'Friday': 'Vendredi',
      'Saturday': 'Samedi',
      'Sunday': 'Dimanche',
    };
    return days[dayOfWeek] ?? dayOfWeek;
  }

  // Créer une copie avec des modifications
  Schedule copyWith({
    String? id,
    String? courseId,
    String? teacherId,
    String? dayOfWeek,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? room,
  }) {
    return Schedule(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      teacherId: teacherId ?? this.teacherId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
    );
  }

  @override
  String toString() {
    return 'Schedule(id: $id, courseId: $courseId, dayOfWeek: $dayOfWeek, '
           'startTime: ${startTimeFormatted}, endTime: ${endTimeFormatted}, room: $room)';
  }
}