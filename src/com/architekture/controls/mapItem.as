class com.architekture.controls.mapItem extends mx.core.UIComponent {
	private var label:String;
	private var bounds:Object;
	private var fillColor:Number = 0xffee00;
	private var fillColor2:Number = 0xeedd00;
	private var highlightColor:Number = 0xffff33;
	private var strokeColor:Number = 0x888888;
	private var strokeWidth:Number = 1;
	private var indent:Number = 2;
	private var shadowOffset:Number = 3;
	private var label_tf:TextField;
	private var state:String = "up";
	function mapItem () {
		super ();
	}
	function init () {
		super.init ();
		if (bounds.w > 20 && bounds.h > 20) {
			var tWidth = Math.abs (bounds.w - 2 * indent);
			var tHeight = Math.abs (bounds.h - 2 * indent);
			createTextField ("label_tf", 10, bounds.x + indent, bounds.y + indent, tWidth, tHeight);
			var tf = new TextFormat ("Arial", 10, 0);
			//		trace("width = "+(bounds.w -2*indent));
			tf.align = "center";
			label_tf.setNewTextFormat (tf);
			label_tf.embedFonts = true;
			label_tf.multiline = true;
			label_tf.wordWrap = true;
			if (bounds.h > 40) {
				label_tf.autoSize = true;
			}
			label_tf.text = label;
			label_tf.selectable = false;
			label_tf._y = bounds.y + indent + bounds.h / 2 - (label_tf._height - 2 * indent) / 2;
		}
		invalidate ();
	}
	function drawRectangle (x, y, w, h) {
		moveTo (x, y);
		lineTo (x + w, y);
		lineTo (x + w, y + h);
		lineTo (x, y + h);
		endFill ();
	}
	function drawShadowedRectangle (x, y, w, h) {
		switch (state) {
		case "over" :
			var c1:Number = fillColor;
			var c2:Number = highlightColor;
			break;
		case "down" :
			var c1:Number = fillColor2;
			var c2:Number = fillColor;
			break;
		default :
			var c1:Number = fillColor;
			var c2:Number = fillColor2;
			break;
		}
		if (state != "down") {
			beginFill (0, 20);
			drawRectangle (x + shadowOffset, y + shadowOffset, w, h);
		}
		lineStyle (strokeWidth, strokeColor, 100);
		var colors = [Number (c1), Number (c2)];
		var alphas = [100, 100];
		var ratios = [0, 0xFF];
		var matrix = {matrixType:"box", x:x, y:y, w:w, h:w, r:(45 / 180) * Math.PI};
		beginGradientFill ("linear", colors, alphas, ratios, matrix);
		drawRectangle (x, y, w, h);
	}
	function draw () {
		clear ();
		drawIndentRectangle (4);
	}
	function drawIndentRectangle () {
		drawShadowedRectangle (bounds.x + indent, bounds.y + indent, bounds.w - 2 * indent, bounds.h - 2 * indent);
	}
	function onRollOver () {
		state = "over";
		invalidate ();
	}
	function onRollOut () {
		state = "up";
		invalidate ();
	}
	function onPress () {
		state = "down";
		invalidate ();
	}
	function onRelease () {
		state = "over";
		invalidate ();
	}
	function onReleaseOutside () {
		state = "up";
		invalidate ();
	}
}
