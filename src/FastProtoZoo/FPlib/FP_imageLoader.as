//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
//
//USE it instead of loadImage if wants to maintain flash 6 compatibility
//
class FastProtoZoo.FPlib.FP_imageLoader{
	//target_mc to the MovieClip
	private var target_mc, owner, parentreference:MovieClip;
	private var fcolor, sampler:Number;
	private var loadmessage, callfunction:String;
	private var callbacktarget:Object;
	// constructor , passing the reference to the target clip container
	function FP_imageLoader(reference:MovieClip, parentreference:MovieClip) {
		//assign owner
		this.owner = reference;
		//
		if (parentreference) {
			this.parentreference = parentreference;
		} else {
			this.parentreference = this.owner;
		}
		//load message default
		this.loadmessage = "";
		//init
		this.target_mc = this.owner;
	}
	//load the image
	public function loadClip(from:String, offsetx:Number, offsety:Number):Void {
		//clear sampler
		clearInterval(this.sampler);
		//create a container
		this.target_mc.createEmptyMovieClip("image", 1);
		if (offsetx) {
			this.target_mc.image._x = offsetx;
		}
		if (offsety) {
			this.target_mc.image._y = offsety;
		}
		//call the supre calss method
		this.target_mc.image.loadMovie(from);
		//show bar and label and reset barfill
		this.target_mc.bar._visible = true;
		this.target_mc.bar.barfill._xscale = 0;
		this.target_mc.loadinglabel._visible = true;
		//set label
		this.setLabel("init");
		//sampler
		this.sampler=setInterval(this,"sample",10);
		//load start
		this.onLoadStart();
	}
	//show the loader bar
	public function viewLoader(fillColor:Number, xo:Number, yo:Number, barwidth:Number, message:String,barheight:Number):Void {
		//default value
		if (barwidth == undefined) {
			barwidth = 50;
		}
		if (barheight==undefined){
			barheight=5;
		}
		//store the color
		this.fcolor = fillColor;
		//create elements
		this.target_mc.createEmptyMovieClip("bar", 3);
		this.target_mc.bar.createEmptyMovieClip("barfill", 1);
		this.target_mc.bar.createEmptyMovieClip("barline", 2);
		this.target_mc.bar.barfill.beginFill(fillColor, 80);
		this.target_mc.bar.barfill.moveTo(0, 0);
		this.target_mc.bar.barfill.lineTo(barwidth, 0);
		this.target_mc.bar.barfill.lineTo(barwidth, barheight);
		this.target_mc.bar.barfill.lineTo(0, barheight);
		this.target_mc.bar.barfill.lineTo(0, 0);
		this.target_mc.bar.barfill.endFill();
		//outline
		this.target_mc.bar.barline.lineStyle(1, fillColor, 100);
		this.target_mc.bar.barline.moveTo(0, 0);
		this.target_mc.bar.barline.lineTo(barwidth, 0);
		this.target_mc.bar.barline.lineTo(barwidth, barheight);
		this.target_mc.bar.barline.lineTo(0, barheight);
		this.target_mc.bar.barline.lineTo(0, 0);
		//attach label
		this.target_mc.bar.createTextField("loadinglabel", 3, 0, 3, barheight+5, 10);
		this.target_mc.bar.loadinglabel.autoSize = "left";
		this.target_mc.bar.loadinglabel.selectable=false;
		//set defaults
		if (message == undefined) {
			this.loadmessage = "Loading...";
		} else {
			this.loadmessage = message;
		}
		//set the position
		this.target_mc.bar._x = xo;
		this.target_mc.bar._y = yo;
		//reset barfillscale
		this.target_mc.bar.barfill._xscale = 0;
		//hide first
		this.target_mc.bar._visible = false;
		this.target_mc.loadinglabel._visible = false;
	}
	//on progress change bar size
	public function sample():Void {
		//
		if (this.target_mc.image.getBytesLoaded()>1 && this.target_mc.image.getBytesLoaded()==this.target_mc.image.getBytesTotal()){
			this.onLoadComplete();
		}else if(this.target_mc.image.getBytesLoaded()>1) {
			this.target_mc.bar.barfill._xscale = (this.target_mc.image.getBytesLoaded()/this.target_mc.image.getBytesTotal())*100;
		} else {
			this.target_mc.bar.barfill._xscale = 0;
		}
	}
	//start loading
	public function onLoadStart():Void {
		//message
		this.setLabel(this.loadmessage);
	}
	//end loading
	public function onLoadComplete():Void {
		//
		this.target_mc.bar._visible = false;
		this.target_mc.loadinglabel._visible = false;
		//set a reference
		this.target_mc.image._parent = this.parentreference;
		//tell to target that movie has been loaded
		if (this.callbacktarget!=undefined){
			this.callbacktarget[this.callfunction]();
		}
		//clear sampler
		clearInterval(this.sampler);
	}
	//error
	public function onLoadError(reference:MovieClip, errorcode:String):Void {
		//LoadNeverCompleted
		this.target_mc.bar._visible = true;
		this.target_mc.loadinglabel._visible = true;
		//set defaults
		this.setLabel("error:"+errorcode);
	}
	//
	private function setLabel(label:String):Void {
		//message
		this.target_mc.bar.loadinglabel.text = label;
		//textformat
		var style:TextFormat = new TextFormat();
		style.font = "Arial";
		style.size = 10;
		style.bold = true;
		style.color = this.fcolor;
		this.target_mc.bar.loadinglabel.setTextFormat(style);
	}
	//
	public function setCallback(owner:Object,callfunction:String):Void{
		this.callbacktarget=owner;
		this.callfunction=callfunction;
	}
}
