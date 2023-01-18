//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPlib.FP_imageLoader;
import FastProtoZoo.FPhtmlRender.*;
//
class FastProtoZoo.FPhtmlRender.htmlRender_layout extends MovieClip {
	//############ ATTACH ON THE FLY ###############################################
	static var symbolName:String = "__Packages.FastProtoZoo.FPhtmlRender.htmlRender_layout";
	static var symbolOwner:Function = FastProtoZoo.FPhtmlRender.htmlRender_layout;
	static var symbolLinked:Object = Object.registerClass(symbolName, symbolOwner);
	//############ ATTACH ON THE FLY ###############################################
	private var doc:Array;
	private var loader:FP_imageLoader;
	private var counter, lcounter,w,h:Number;
	private var bg:MovieClip;
	private var mother:Object;
	private var layers:Array;
	//
	function htmlRender_layout () {
		//defaults
		this.w=this.h=300;
		//
		this.counter = 0;
		this.lcounter = 0;
		//create an instance of the class
		this.loader = new FP_imageLoader (this.bg);
		//init layers container
		this.layers=new Array();
	}
	//
	public function render (structure:XML):Void {
		//reset first
		this.reset ();
		//init layers container
		this.layers=new Array();
		//
		trace("[FPXHTMLRENDER::start_rendering]");
		var doc:Array = new Array ();
		doc = structure.childNodes;
		//
		for (var k = 0; k < doc.length; k++) {
			//doc
			if (doc[k].nodeName == "html") {
				//begin from html
				var a:Array = new Array ();
				a = doc[k].childNodes;
				//parse the file and find the body structure
				for (var i = 0; i < a.length; i++) {
					if (a[i].nodeName == "body") {
						//search for bg attributes and attach image
						if (a[i].attributes.bg.length > 0) {
							this.createEmptyMovieClip ("bg", 1);
							this.loader.loadClip (a[i].attributes.bg);
							this.loader.viewLoader (0x000000, 0, 0, 100, "Loading BG");
						}
						//relative y position
						var relh=0;
						//
						var b:Array = a[i].childNodes;
						for (var j = 0; j < b.length; j++) {
							//attach elements
							if (b[j].nodeName.toLowerCase()== "table") {
								var init = new Object ();
								init.struct = new Array();
								init.struct = b[j];
								init.mother=this.mother;
								init._y=relh;
								//attach element
								this.attachMovie (htmlRender_table.symbolName, "t" + this.counter, this.counter, init);
								//store h and add 2 px spacer
								relh=Math.round(this["t"+this.counter]._height);
								//
								this.counter++;
							}else if (b[j].nodeName.toLowerCase() == "div") {
								var init = new Object ();
								init.struct = new Array();
								init.struct = b[j];
								init.mother=this.mother;
								//create it and place an offset into z layer of 100
								var id=b[j].attributes.id;
								//
								var extracted=new Array();
								extracted=b[j].attributes.style.split(';');
								//extract values
								for (var w=0;w<extracted.length;w++){
									if (extracted[w].indexOf("z-index")!=-1){
										var temp=extracted[w].split(':');
										var level=Number(temp[1]);
									}
								}
								this.attachMovie (htmlRender_div.symbolName, "l"+this.lcounter, level+100000, init);
								//store layer name
								this.layers.push({name:id,target:this["l"+this.lcounter]});
								//
								this.lcounter++;
							}
						}
					}
				}
			}
		}
	}
	//
	public function reset ():Void {
		//delete tables
		for (var i = 0; i <= this.counter; i++) {
			this["t" + i].removeMovieClip ();
		}
		//delete layers
		for (var i = 0; i <= this.layers.length; i++) {
			this.layers[i].target.removeMovieClip ();
		}
	}
	//drive layers
	public function setLayerStyle(id:String,style:Object):Void{
		//search element and then drive it
		for (var i=0;i<this.layers.length;i++){
			if (this.layers[i].name==id){
				trace("[FPXHTMLRENDER::drive_layer: '"+id+"']");
				this.layers[i].target.setStyle(style);
				//if found break
				break;
			}
		}
	}
	//set width and height
	public function setDims(w:Number,h:Number):Void{
		this.w=w;
		this.h=h;
	}
	//get dims
	public function getDims():Object{
		return({width:this.w,height:this.h});
	}
}
