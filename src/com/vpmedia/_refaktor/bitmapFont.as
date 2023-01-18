import flash.display.*;
import flash.geom.*;
class bitmapFont {
	function bitmapFont () {
	}
	public static function drawText (bmp:BitmapData, color:Number, text:String, position:Rectangle, zoom:Number) {
		var x = position.x;
		var x_orig = x;
		var y = position.y;
		var y_orig = y;
		var width = position.width;
		var height = position.height;
		var __font:Object = new Object ();
		__font.char_0 = [7, 5, 5, 5, 7];
		__font.char_1 = [1, 1, 1, 1, 1];
		__font.char_2 = [7, 1, 7, 4, 7];
		__font.char_3 = [7, 1, 7, 1, 7];
		__font.char_4 = [5, 5, 7, 1, 1];
		__font.char_5 = [7, 4, 7, 1, 7];
		__font.char_6 = [4, 4, 7, 5, 7];
		__font.char_7 = [7, 1, 1, 1, 1];
		__font.char_8 = [7, 5, 7, 5, 7];
		__font.char_9 = [7, 5, 7, 1, 7];
		__font.char_a = [2, 5, 5, 7, 5];
		__font.char_b = [6, 5, 6, 5, 6];
		__font.char_c = [7, 4, 4, 4, 7];
		__font.char_d = [6, 5, 5, 5, 6];
		__font.char_e = [7, 4, 7, 4, 7];
		__font.char_f = [7, 4, 7, 4, 4];
		__font.char_g = [3, 4, 4, 5, 3];
		__font.char_h = [5, 5, 7, 5, 5];
		__font.char_i = [2, 2, 2, 2, 2];
		__font.char_j = [1, 1, 1, 5, 3];
		__font.char_k = [5, 6, 4, 6, 5];
		__font.char_l = [4, 4, 4, 4, 7];
		__font.char_m = [5, 7, 5, 5, 5];
		__font.char_n = [5, 5, 7, 7, 5];
		__font.char_o = [3, 5, 5, 5, 3];
		__font.char_p = [6, 5, 6, 4, 4];
		__font.char_q = [2, 5, 5, 5, 3];
		__font.char_r = [6, 5, 6, 5, 5];
		__font.char_s = [3, 4, 2, 1, 6];
		__font.char_t = [7, 2, 2, 2, 2];
		__font.char_u = [5, 5, 5, 5, 3];
		__font.char_v = [5, 5, 5, 5, 2];
		__font.char_w = [5, 5, 5, 7, 5];
		__font.char_x = [5, 5, 2, 5, 5];
		__font.char_y = [5, 5, 2, 2, 2];
		__font.char_z = [7, 1, 2, 4, 7];
		__font.char_point = [0, 0, 0, 0, 2];
		__font.char_decimal = [0, 0, 0, 2, 2];
		__font.char_plus = [0, 2, 7, 2, 0];
		__font.char_minus = [0, 0, 7, 0, 0];
		__font.char_equal = [0, 7, 0, 7, 0];
		__font.char_space = [0, 0, 0, 0, 0];
		var bits = 3;
		//lower case... we have just lower case font
		text = text.toLowerCase ();
		var len = text.length;
		for (var i = 0; i < len; i++) {
			var char = text.substr (i, 1);
			switch (char) {
			case "." :
				var char_data = __font["char_point"];
				break;
			case "," :
				var char_data = __font["char_decimal"];
				break;
			case "+" :
				var char_data = __font["char_plus"];
				break;
			case "-" :
				var char_data = __font["char_minus"];
				break;
			case "=" :
				var char_data = __font["char_equal"];
				break;
			case " " :
				var char_data = __font["char_space"];
				break;
			default :
				var char_data = __font["char_" + char];
			}
			var char_len = char_data.length;
			for (var j = 0; j < char_len; j++) {
				var data = char_data[j];
				for (var b = 0; b < bits; b++) {
					if (data & Math.pow (2, b)) {
						bmp.fillRect (new Rectangle (Math.floor (x + (bits - b) * zoom), Math.floor (y + j * zoom), Math.ceil (zoom), Math.ceil (zoom)), color);
					}
				}
			}
			x += zoom * 4;
			if (x > (x_orig + width)) {
				x = x_orig;
				y += zoom * 6;
				if (y >= (y_orig + height)) {
					break;
				}
			}
		}
	}
}
