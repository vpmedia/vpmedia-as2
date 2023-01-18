//
import com.FlashDynamix.types.String2;
import com.FlashDynamix.types.Boolean2;
import com.FlashDynamix.types.Date2;
//
class com.FlashDynamix.types.Parse {
	public static function value(value) {
		var numStr = (value.indexOf(".") != -1) ? String2.trimEnd(value, "0") : value;
		if (!isNaN(parseFloat(value)) && parseFloat(value).toString().length == numStr.length && value.toLowerCase().indexOf("e") == -1) {
			return parseFloat(value);
		} else if (Boolean2.parse(value) != undefined) {
			return Boolean2.parse(value);
		} else if (Date2.parse(value) != undefined) {
			return Date2.parse(value);
		}
		return (value == null) ? "" : value;
	}
}