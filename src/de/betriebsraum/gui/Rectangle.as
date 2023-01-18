class de.betriebsraum.gui.Rectangle {	


	private var rect_mc:MovieClip;


	public function Rectangle(target:MovieClip, depth:Number, x:Number, y:Number) {

		rect_mc = target.createEmptyMovieClip("rect_mc"+depth, depth);
		rect_mc._x = x;
		rect_mc._y = y;
		
	}
	
	
	public function draw(w:Number, h:Number, style:Object):MovieClip {

		rect_mc.moveTo(0, 0);
		rect_mc.beginFill(style.color != undefined ? style.color : 0x0000FF, style.alpha != undefined ? style.alpha : 100); 
		rect_mc.lineTo(w, 0);
		rect_mc.lineTo(w, h);
		rect_mc.lineTo(0, h);
		rect_mc.lineTo(0, 0);
		rect_mc.endFill();
		
		return rect_mc;
		
	}
	
	
}