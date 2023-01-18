class com.vpmedia.input.DoubleClick extends MovieClip {
	private var intervalId:Number;
	public var onDoubleClick:Function = new Function();
	public var onSingleClick:Function = new Function();
	private function onRelease() {
		if (this.intervalId) {
			this.onDoubleClick();
			clearInterval(this.intervalId);
			this.intervalId = 0;
		} else {
			this.intervalId = setInterval(this, "SingleClickHandler", 200, this);
		}
	}
	
	private function SingleClickHandler(mc:MovieClip) {
		if (mc.intervalId) {
			this.onSingleClick();
			clearInterval(mc.intervalId);
			mc.intervalId = 0;
		}
	}	
}
