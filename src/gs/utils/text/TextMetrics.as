/*
VERSION: 1.5
DATE: 8/7/2007
ACTIONSCRIPT VERSION: 2.0
DESCRIPTION:
	Have you ever needed to find out where the line breaks occur in a dynamic TextField? How about the precise x/y coordinates
	of a particular phrase/string along with its width & height so that you could highlight it somehow? Or maybe the width of
	each line of text? That's all possible with the gs.utils.text.TextMetrics class. And to be consistent with the getTextLineMetrics() 
	function in the TextField AS3 class, we also return the descent, ascent, and leading values too. This class's version is just
	a more powerful version of the one in AS3 and it's available in AS2. You must publish to Flash 8 or later for accurate results.
	

EXAMPLES: 
	To put a red box over every instance of the word "ActionScript" in the TextField named my_tf, do:
	
		import gs.utils.text.TextMetrics;
		
		var my_tf = this.createTextField("tf", this.getNextHighestDepth(), 20, 20, 300, 300);
		my_tf.multiline = true;
		my_tf.wordWrap = true;
		var format = new TextFormat();
		format.size = 18;
		my_tf.text = "ActionScript makes me happy. Except I hate the way ActionScript handles text and fonts. I wish I didn't have to create this ActionScript class and that Adobe added built-in functions to handle these tasks. But alas, nothings is perfect. Good luck using this ActionScript class folks.";
		my_tf.setTextFormat(format);
		var instances_array = TextMetrics.getSubstringMetrics(my_tf, "ActionScript");
		var instance;
		for (var i = 0; i < instances_array.length; i++) {
			instance = instances_array[i];
			box(this, instance.x, instance.y, instance.width, instance.height);
		}
		function box(parent, x, y, width, height):MovieClip {
			var l = parent.getNextHighestDepth();
			var mc = parent.createEmptyMovieClip("box"+l, l);
			mc.beginFill(0xFF0000);
			mc.moveTo (0, 0);
			mc.lineTo (width, 0);
			mc.lineTo (width, height);
			mc.lineTo (0, height);
			mc.lineTo (0, 0);
			mc.endFill();
			mc._x = x;
			mc._y = y;
			mc._alpha = 50;
			return mc;
		}
	

NOTES:
	- Flash isn't always perfectly accurate in the measurement of text, so your results may vary.
	- Must publish to Flash 8 or later for accurate results.
	- Will NOT work for static TextFields

CODED BY: Jack Doyle, jack@greensock.com
Copyright 2007, GreenSock (This work is subject to the terms in http://www.greensock.com/terms_of_use.html.)
*/

class gs.utils.text.TextMetrics {
	
	static function getTextBounds(tf:TextField):Object { //Returns an object with the xMin, xMax, yMin, and yMax, x, y, textWidth, and textHeight of the TEXT inside of a TextField (not the TextField box)
		var fmt = tf.getTextFormat(0,1);
		var bounds = {};
		if (fmt.align == "right") {
			bounds.xMax = tf._x + tf._width - 2; //There's a 2-pixel margin on TextFields.
		} else if (fmt.align == "center") {
			bounds.xMax = tf._x + (tf._width / 2) + (tf.textWidth / 2);
		} else {
			bounds.xMax = tf._x + tf.textWidth + 2; //There's a 2-pixel margin on TextFields.
		}
		bounds.xMin = bounds.xMax - tf.textWidth;
		bounds.yMax = tf._y + tf.textHeight + 2; //There's a 2-pixel margin on TextFields.
		bounds.yMin = tf._y + 2;
		bounds.y = bounds.yMin;
		bounds.x = bounds.xMin;
		bounds.textWidth = tf.textWidth;
		bounds.textHeight = tf.textHeight;
		return bounds;
	}
	
	static function getLineMetrics(tf:TextField):Array { //Goes through each line of a TextField, measures its textWidth and textHeight and it's x and y coordinate and returns an array of objects (one for each line). The objects have the following properties: x, y,width, height, leading, ascent, descent, and text
		var final_array = []; //Measurements array - one for each line of text.
		var format = tf.getTextFormat(0,1);
		var originalLeading = format.leading;
		var originalExtent = format.getTextExtent("Mg");
		format.leading = 0;
		tf.setNewTextFormat(format); //Otherwise the formatting got lost on dynamically-created TextFields!
		var lines_array = tf.text.split(String.fromCharCode(13)); //Takes hard-coded line breaks into consideration. We split the string apart at each of them.
		var originalText = tf.text; 
		var originalHeight = tf._height;
		tf.text = "Mg";
		var textHeight = tf.textHeight;
		format.leading = originalLeading;
		tf.setNewTextFormat(format); //Otherwise the formatting got lost on dynamically-created TextFields!
		tf.text = "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M" + newline + "M"; //Just needed something with a tall ascender and a low descender for measurement purposes.
		var lineHeight = tf.textHeight / 20 + (format.leading / 20); //We used 20 lines and averaged them to find a more accurate space between. When we only used one, it started drifting slightly after a few lines (more and more as the number of lines increased).
		var padY = 3; //To accommodate the 3 pixel margin at the top of the TextField.
		var lastWidth = 0; 
		var lastText = "";
		tf.text = "";
		tf._height = lineHeight + 6;//Just give it some breathing room - we don't want to risk cutting off the first line.
		var words_array, x, i, j;
		for (i = 0; i < lines_array.length; i++) {
			words_array = lines_array[i].split(" ");
			for (j = 0; j < words_array.length; j++) { //Loop through and add each word to the TextField one by one until the line breaks (maxscroll > 1).
				tf.text += words_array[j] + " ";
				if (tf.maxscroll != 1) {
					if (format.align == "right") {
						x = tf._x + tf._width - lastWidth - 2; //There's a 2-pixel margin on TextFields.
					} else if (format.align == "center") {
						x = tf._x + (tf._width / 2) - (lastWidth / 2);
					} else {
						x = tf._x + 2; //There's a 2-pixel margin on TextFields.
					}
					final_array.push({text:lastText, x:x, y:padY + tf._y + Math.round(final_array.length * (lineHeight)), width:lastWidth, height:textHeight, lineHeight:lineHeight, leading:originalLeading, ascent:originalExtent.ascent, descent:originalExtent.descent});
					tf.text = words_array[j] + " ";
				}
				lastWidth = tf.textWidth; 
				lastText = tf.text;
			}
			lastText = lastText.substr(0, lastText.length - 1); //Just get rid of the extra space at the end.
			if (format.align == "right") { //I realize this is duplicate code from above which could be wrapped into a function, but doing so would hurt performance and since this function demands a lot from the processor, I thought it best to prioritize performance.
				x = tf._x + tf._width - lastWidth - 2; //There's a 2-pixel margin on TextFields.
			} else if (format.align == "center") {
				x = tf._x + (tf._width / 2) - (lastWidth / 2);
			} else {
				x = tf._x + 2; //There's a 2-pixel margin on TextFields.
			}
			final_array.push({text:lastText, x:x, y:padY + tf._y + Math.round(final_array.length * (lineHeight)), width:lastWidth, height:textHeight, lineHeight:lineHeight, leading:originalLeading, ascent:originalExtent.ascent, descent:originalExtent.descent});
			tf.text = "";
			lastWidth = 0;
			lastText = "";
		}
		tf._height = originalHeight;
		tf.text = originalText;
		return final_array;
	}
	
	
	static function getSubstringMetrics(tf:TextField, text_str:String):Array { //Finds the x, y, width, height, leading, ascent, descent, and lineHeight of all of the instances of a given string within a TextField
		var instances_array = [];
		var lines_array = getLineMetrics(tf);
		var ascent = lines_array[0].ascent;
		var descent = lines_array[0].descent;
		var lineHeight = lines_array[0].lineHeight;
		var leading = lines_array[0].leading;
		var format = tf.getTextFormat(0,1);
		tf.setNewTextFormat(format); //Otherwise the formatting got lost on dynamically-created TextFields!
		var originalText = tf.text; 
		var originalHeight = tf._height;
		tf.text = text_str;
		var te = format.getTextExtent(text_str);
		var textWidth = Math.max(te.width, tf.textWidth); //Sometimes one is slightly more accurate than the other - we'll always use the bigger number though.
		var textHeight = lines_array[0].height;
		tf.text = "M";
		var mWidth = tf.textWidth;
		var i, j, ia, line, index, x;
		for (i = 0; i < lines_array.length; i++) {
			line = lines_array[i];
			ia = line.text.split(text_str);
			ia.pop();
			tf.text = "";
			for (j = 0; j < ia.length; j++) {
				tf.text += ia[j] + "M"; //We pad the end with an "M" in case there is one or more spaces at the end (which Flash ignores in measurements in center- and right-aligned TextFields		
				instances_array.push({x:line.x + tf.textWidth - mWidth, y:line.y, width:textWidth, height:textHeight, lineHeight:lineHeight, leading:leading, ascent:ascent, descent:descent});
				tf.text = tf.text.substr(0, -1) + text_str;
			}
		}
		tf._height = originalHeight;
		tf.text = originalText;
		return instances_array;
	}	
	
}