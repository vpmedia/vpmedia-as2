class janumedia.stage_cover extends MovieClip {
	var isFilled:Boolean;
	function stage_cover() {
		//_global.tt("[StageCover] stage_cover");
		this.useHandCursor = false;
		this.onPress = function() {
		};
		Stage.addListener(this);
		//clear();
	}
	function onResize() {
		//_global.tt("[StageCover] onResize");
		if (isFilled) {
			drawRec();
		}
	}
	function drawRec() {
		//_global.tt("[StageCover] drawRec");
		isFilled = true;
		beginFill(0x000000, 50);
		moveTo(0, 0);
		lineTo(Stage.width, 0);
		lineTo(Stage.width, Stage.height);
		lineTo(0, Stage.height);
		lineTo(0, 0);
		endFill();
	}
	function clearRec() {
		//_global.tt("[StageCover] clearRec");
		isFilled = false;
		this.clear();
	}
}
