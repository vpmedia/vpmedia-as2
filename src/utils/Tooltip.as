// CLASS 	Tooltip.as

// VERSION	1.1 (compatible with Flash MX2004; Flash Player 7 >)

// MODIFIED	18-11-2003

// AUTHOR	         Laiverd.COM - John Mulder 2003

// SUMMARY	Create tooltips on the fly; timer was added in version 1.1 so that it takes some

//		short time before the tip displays and automatically diappears after a certain time.

//		

// PARAMETERS	newText:String	:text to be displayed in tooltip

//		tColor:Number	:backgroundcolor of the tooltip (optional) define in hex format(0x000000)

//		txtColor:Number	:color of the text (optional) define in hex format(0x000000)

// PUBLIC METHODS	drawTip()		:puts the tooltip on stage at mouse position
//		removeTip()	:removes the tooltip from the stage
//

//++++++++++++++++++++++++ EXAMPLE USAGE ++++++++++++++++++++++++++++++++++++++++++++++++++++
//	var btnTip:Tooltip = new Tooltip("This is the tooltip text.");
//	mc1.onRollOver = function() {
//		btnTip.drawTip();
//	};
//	mc1.onRollOut = function() {
//		btnTip.removeTip();
//	};

//
//	Would create a new tooltip named 'btnTip'. The drawTip() method is triggered by the 
//	onRollOver event of the movieclip named 'mc1'. The removeTip() method is triggered by the 
//	onRollOut event of the movieclip 'mc1'.

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

class utils.Tooltip {
	// CLASS PROPERTIES
	private var $borderC:Number;
	private var $toolTipW:Number;
	private var $toolTipH:Number;
	private var $pointerW:Number;
	private var $pointerH:Number;
	private var $baseDist:Number;
	private var $tColor:Number;
	private var $txtColor:Number;
	private var $tipText:String;
	private var $textWidth:Number;
	private var $textHeight:Number;
	private var $tipFormat:TextFormat;
	private var $tTxtSize:Number;
	private var $tTxtFont:String;
	private var $tTxtAlign:String;
	private var $tTxtLeading:Number;
	private var $timer:Object;
	private var $dTime:Number;
	private var $sTime:Number;
	// CONSTRUCTOR +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	function Tooltip(newText:String, tColor:Number, txtColor:Number) {
		this.tipText = newText;
		this.tipBackgroundColor = tColor;
		this.tipTextColor = txtColor;
		// non parametrised
		this.baseDistance = 15;
		this.pointerHeight = 15;
		this.pointerWidth = 10;
		this.toolTipWidth = 200;
		this.tipBorderColor = 0x000000;
		this.tipTextSize = 10;
		this.tipTextFont = "_sans";
		this.tipTextAlign = "left";
		this.tipTextLeading = 3;
		// seconds, NOT milliseconds
		this.tipDelayTime = 0.5;
		// seconds, NOT milliseconds
		this.tipShowTime = 3;
	}
	// METHODS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	// function that after a timeout of .5 seconds, draws the tooltip by calling doDraw();
	public function drawTip() {
		this.$timer = new Object();
		$timer.displayTipDelay = setInterval(this, "doDraw", tipDelayTime);
	}
	// function to remove the tip --------------------------------------------------------------
	public function removeTip() {
		if ($timer.tipDisplayTime) {
			clearTimer($timer.tipDisplayTime);
			trace("$timer.tipDisplayTime cleared");
		}
		if ($timer.displayTipDelay) {
			clearTimer($timer.displayTipDelay);
			trace("$timer.displayTipDelay cleared");
		}
		if (_root.tooltipHolder != undefined) {
			removeMovieClip("tooltipHolder");
		}
		delete this.$timer;
	}
	// parametrised function to clear any interval ---------------------------------------------
	private function clearTimer(whatTimer) {
		trace("clearTimer called");
		clearInterval(whatTimer);
	}
	// drawing the tooltip ---------------------------------------------------------------------
	private function doDraw() {
		// clear the timer that delayed the tooltip display ------------------------------------
		clearTimer($timer.displayTipDelay);
		// start the timer that determines the time that the tooltip will be displayed ---------
		$timer.tipDisplayTime = setInterval(this, "removeTip", tipShowTime);
		// tooltip holder ----------------------------------------------------------------------
		_root.createEmptyMovieClip("tooltipHolder", 10000);
		// new textformat ----------------------------------------------------------------------
		var $tipFormat = new TextFormat();
		$tipFormat.color = tipTextColor;
		$tipFormat.font = tipTextFont;
		$tipFormat.size = tipTextSize;
		$tipFormat.leading = tipTextLeading;
		$tipFormat.align = tipTextAlign;
		// creating measures for textfield -----------------------------------------------------
		var metrics = $tipFormat.getTextExtent(this.$tipText, this.toolTipWidth);
		var tmpFieldHeight = metrics.textFieldHeight;
		$textWidth = toolTipWidth;
		$textHeight = tmpFieldHeight + 3;
		// create textfield inside tooltipHolder -----------------------------------------------
		_root.tooltipHolder.createTextField("tipField", 5, 2, 2, $textWidth - 4, $textHeight);
		_root.tooltipHolder["tipField"].border = 0;
		_root.tooltipHolder["tipField"].selectable = 0;
		_root.tooltipHolder["tipField"].embedFonts = 0;
		_root.tooltipHolder["tipField"].wordWrap = 1;
		_root.tooltipHolder["tipField"].type = "dynamic";
		_root.tooltipHolder["tipField"].text = $tipText;
		_root.tooltipHolder["tipField"].setTextFormat($tipFormat);
		// tooltip shape movieclip inside tooltipHolder ----------------------------------------
		_root.tooltipHolder.createEmptyMovieClip("shape", 2);
		// draw tooltip background -------------------------------------------------------------
		toolTipHeight = this.$textHeight;
		with (_root.tooltipHolder.shape) {
			beginFill(this.tipBackgroundColor, 100);
			moveTo(0, 0);
			lineTo(this.toolTipWidth, 0);
			lineTo(this.toolTipWidth, this.toolTipHeight);
			lineTo(this.baseDistance + this.pointerWidth, this.toolTipHeight);
			lineTo(this.baseDistance + this.pointerWidth, this.toolTipHeight + this.pointerHeight);
			lineTo(this.baseDistance, this.toolTipHeight);
			lineTo(0, this.toolTipHeight);
			lineTo(0, 0);
			endFill();
		}
		// draw tooltip outline inside tooltipHolder -------------------------------------------
		_root.tooltipHolder.createEmptyMovieClip("shapeborder", 3);
		with (_root.tooltipHolder.shapeborder) {
			lineStyle(1, this.tipBorderColor, 100);
			moveTo(0, 0);
			lineTo(this.toolTipWidth, 0);
			lineTo(this.toolTipWidth, this.toolTipHeight);
			lineTo(this.baseDistance + this.pointerWidth, this.toolTipHeight);
			lineTo(this.baseDistance + this.pointerWidth, this.toolTipHeight + this.pointerHeight);
			lineTo(this.baseDistance, this.toolTipHeight);
			lineTo(0, this.toolTipHeight);
			lineTo(0, 0);
		}
		// create dropshadow by duplicating 'shape' inside tooltipHolder -----------------------
		_root.tooltipHolder.shape.duplicateMovieClip("shadow_mc", 1);
		_root.tooltipHolder.shadow_mc._x = _root.tooltipHolder.shape._x + 3.5;
		_root.tooltipHolder.shadow_mc._y = _root.tooltipHolder.shape._y + 3.5;
		_root.tooltipHolder.shadow_mc._alpha = 50;
		var shadow_mc = new Color(_root.tooltipHolder.shadow_mc);
		shadow_mc.setRGB(0x000000);
		// position tooltip at mouse pointer ---------------------------------------------------
		_root.tooltipHolder._x = _root._xmouse - (baseDistance + pointerWidth);
		_root.tooltipHolder._y = _root._ymouse - (pointerHeight + $textHeight);
	}
	// SETTERS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	public function set tipBackgroundColor(tColor:Number):Void {
		if (tColor == undefined) {
			this.$tColor = 0xFFFFCC;
		} else {
			this.$tColor = tColor;
		}
	}
	public function set tipTextColor(txtColor:Number):Void {
		if (txtColor == undefined) {
			this.$txtColor = 0x00000;
		} else {
			this.$txtColor = txtColor;
		}
	}
	public function set tipText(newText:String):Void {
		this.$tipText = newText;
	}
	public function set baseDistance(baseDist:Number):Void {
		this.$baseDist = baseDist;
	}
	public function set pointerHeight(pointerH:Number):Void {
		this.$pointerH = pointerH;
	}
	public function set pointerWidth(pointerW:Number):Void {
		this.$pointerW = pointerW;
	}
	public function set toolTipHeight(toolTipH:Number):Void {
		this.$toolTipH = toolTipH;
	}
	public function set toolTipWidth(toolTipW:Number):Void {
		this.$toolTipW = toolTipW;
	}
	public function set tipBorderColor(borderC:Number):Void {
		this.$borderC = borderC;
	}
	public function set tipTextSize(tTxtSize:Number):Void {
		this.$tTxtSize = tTxtSize;
	}
	public function set tipTextFont(tTxtFont:String):Void {
		this.$tTxtFont = tTxtFont;
	}
	public function set tipTextAlign(tTxtAlign:String):Void {
		this.$tTxtAlign = tTxtAlign;
	}
	public function set tipTextLeading(tTxtLeading:Number):Void {
		this.$tTxtLeading = tTxtLeading;
	}
	public function set tipDelayTime(dTime:Number):Void {
		this.$dTime = dTime * 1000;
	}
	public function set tipShowTime(sTime:Number):Void {
		this.$sTime = sTime * 1000;
	}
	// GETTERS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	public function get tipBackgroundColor() {
		return $tColor;
	}
	public function get tipTextColor() {
		return $txtColor;
	}
	public function get baseDistance() {
		return $baseDist;
	}
	public function get pointerHeight() {
		return $pointerH;
	}
	public function get pointerWidth() {
		return $pointerW;
	}
	public function get toolTipHeight() {
		return $toolTipH;
	}
	public function get toolTipWidth() {
		return $toolTipW;
	}
	public function get tipBorderColor() {
		return $borderC;
	}
	public function get tipTextSize() {
		return $tTxtSize;
	}
	public function get tipTextFont() {
		return $tTxtFont;
	}
	public function get tipTextAlign() {
		return $tTxtAlign;
	}
	public function get tipTextLeading() {
		return $tTxtLeading;
	}
	public function get tipDelayTime() {
		return $dTime;
	}
	public function get tipShowTime() {
		return $sTime;
	}
}