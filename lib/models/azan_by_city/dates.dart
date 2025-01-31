class Designation {
  Designation({
    this.abbreviated,
    this.expanded,
  });

  Designation.fromJson(dynamic json) {
    abbreviated = json['abbreviated'];
    expanded = json['expanded'];
  }

  String? abbreviated;
  String? expanded;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['abbreviated'] = abbreviated;
    map['expanded'] = expanded;
    return map;
  }
}

class Month {
  Month({
    this.number,
    this.en,
    this.ar,
    this.days,
  });

  Month.fromJson(dynamic json) {
    number = json['number'];
    en = json['en'];
    ar = json['ar'];
    days = json['days'];
  }

  num? number;
  String? en;
  String? ar;
  num? days;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number'] = number;
    map['en'] = en;
    map['ar'] = ar;
    map['days'] = days;
    return map;
  }
}

class Weekday {
  Weekday({
    this.en,
    this.ar,
  });

  Weekday.fromJson(dynamic json) {
    en = json['en'];
    ar = json['ar'];
  }

  String? en;
  String? ar;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['en'] = en;
    map['ar'] = ar;
    return map;
  }
}

class Hijri {
  Hijri({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
    this.holidays,
    this.adjustedHolidays,
    this.method,
  });

  Hijri.fromJson(dynamic json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday =
        json['weekday'] != null ? Weekday.fromJson(json['weekday']) : null;
    month = json['month'] != null ? Month.fromJson(json['month']) : null;
    year = json['year'];
    designation = json['designation'] != null
        ? Designation.fromJson(json['designation'])
        : null;
    if (json['holidays'] != null) {
      holidays = [];
      json['holidays'].forEach((v) {
        // holidays?.add(Dynamic.fromJson(v));
      });
    }
    if (json['adjustedHolidays'] != null) {
      adjustedHolidays = [];
      json['adjustedHolidays'].forEach((v) {
        // adjustedHolidays?.add(Dynamic.fromJson(v));
      });
    }
    method = json['method'];
  }

  String? date;
  String? format;
  String? day;
  Weekday? weekday;
  Month? month;
  String? year;
  Designation? designation;
  List<dynamic>? holidays;
  List<dynamic>? adjustedHolidays;
  String? method;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['format'] = format;
    map['day'] = day;
    if (weekday != null) {
      map['weekday'] = weekday?.toJson();
    }
    if (month != null) {
      map['month'] = month?.toJson();
    }
    map['year'] = year;
    if (designation != null) {
      map['designation'] = designation?.toJson();
    }
    if (holidays != null) {
      map['holidays'] = holidays?.map((v) => v.toJson()).toList();
    }
    if (adjustedHolidays != null) {
      map['adjustedHolidays'] =
          adjustedHolidays?.map((v) => v.toJson()).toList();
    }
    map['method'] = method;
    return map;
  }
}
