class com.FlashDynamix.types.Date2 {
	public static function encode(rawDate:Date, dateType:String) {
		var s = new String();
		if (dateType == "dateTime" || dateType == "date") {
			s = s.concat(rawDate.getFullYear(), "-");
			var n = rawDate.getMonth()+1;
			if (n<10) {
				s = s.concat("0");
			}
			s = s.concat(n, "-");
			n = rawDate.getDate();
			if (n<10) {
				s = s.concat("0");
			}
			s = s.concat(n);
		}
		if (dateType == "dateTime") {
			s = s.concat("T");
		}
		if (dateType == "dateTime" || dateType == "time") {
			var n = rawDate.getHours();
			if (n<10) {
				s = s.concat("0");
			}
			s = s.concat(n, ":");
			n = rawDate.getMinutes();
			if (n<10) {
				s = s.concat("0");
			}
			s = s.concat(n, ":");
			n = rawDate.getSeconds();
			if (n<10) {
				s = s.concat("0");
			}
			s = s.concat(n, ".");
			n = rawDate.getMilliseconds();
			if (n<10) {
				s = s.concat("00");
			} else if (n<100) {
				s = s.concat("0");
			}
			s = s.concat(n);
		}
		//   
		s = s.concat("+");
		var zone:Number = -rawDate.getTimezoneOffset()/60;
		var zoneHr = int(zone);
		zoneHr = (zoneHr.toString().length == 1) ? "0"+zoneHr : zoneHr.toString();
		var zoneMins = (zone%int(zone))*60;
		var zoneMins:String = (zoneMins.toString().length == 1) ? "0"+zoneMins : zoneMins.toString();
		s = s.concat(zoneHr+":"+zoneMins);
		//
		return s;
	}
	public static function parse(rawValue:String):Date {
		if (rawValue.indexOf("T") == -1 || rawValue.indexOf(":") == -1 || rawValue.indexOf("-") == -1) {
			return;
		}
		//             
		var d;
		var datePart;
		var timePart;
		var sep = rawValue.indexOf("T");
		var tsep = rawValue.indexOf(":");
		var dsep = rawValue.indexOf("-");
		if (sep != -1) {
			datePart = rawValue.substring(0, sep);
			timePart = rawValue.substring(sep+1);
		} else if (tsep != -1) {
			timePart = rawValue;
		} else if (dsep != -1) {
			datePart = rawValue;
		}
		if (datePart != undefined) {
			var year = datePart.substring(0, datePart.indexOf("-"));
			var month = datePart.substring(5, datePart.indexOf("-", 5));
			var day = datePart.substring(8, 10);
			d = new Date(year, month-1, day);
		} else {
			d = new Date();
		}
		if (timePart != undefined) {
			// check for timezone offset
			var tz = "Z";
			var hourOffset = 0;
			if (datePart.length>10) {
				tz = datePart.substring(10);
			} else if (timePart.length>12) {
				tz = timePart.substring(12);
			}
			if (tz != "Z") {
				var len = tz.length;
				hourOffset = int(tz.substring((len-5), (len-3)));
				if (tz.charAt(len-6) == '+') {
					hourOffset = 0-hourOffset;
				}
			}
			var hours = Number(timePart.substring(0, timePart.indexOf(":")));
			var minutes = timePart.substring(3, timePart.indexOf(":", 3));
			var seconds = timePart.substring(6, timePart.indexOf(".", 6));
			var millis = timePart.substr(9, 3);
			d.setHours(hours, minutes, seconds, millis);
			d = new Date(d.getTime()+(hourOffset*3600000));
		}
		if (d.valueOf() == new Date().valueOf() || isNaN(d.valueOf())) {
			d = undefined;
		}
		return d;
	}
	/**
	@ignore
	*/
	public static function get stamp():String {
		var dateStamp:Date = new Date();
		return dateStamp.getDate()+"/"+dateStamp.getMonth()+"/"+dateStamp.getYear()+" "+dateStamp.getHours()+" : "+dateStamp.getMinutes()+" : "+dateStamp.getMilliseconds();
	}
}
