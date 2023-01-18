//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPlib.FP_drawPrimitives;
import FastProtoZoo.FPhtmlRender.*;
//
class FastProtoZoo.FPhtmlRender.htmlRender_cell extends MovieClip {
	//############ ATTACH ON THE FLY ###############################################
	static var symbolName:String = "__Packages.FastProtoZoo.FPhtmlRender.htmlRender_cell";
	static var symbolOwner:Function = FastProtoZoo.FPhtmlRender.htmlRender_cell;
	static var symbolLinked:Object = Object.registerClass(symbolName, symbolOwner);
	//############ ATTACH ON THE FLY ###############################################
	private var w, h, cellpadding,offset:Number;
	private var element,childCell:MovieClip;
	private var mother:Object;
	private var struct:Array;
	private var cssExtractor:htmlRender_cssExtractor;
	//
	function htmlRender_cell() {
		//table with border offset
		this.offset=0;
		//set the height and the width
		this.w = this.struct.attributes.width;
		this.h = this.struct.attributes.height;
		//helper
		if (!(this.w>0)){
			this.w=100;
		}
		//cellspacing
		if (this.cellpadding==undefined){
			this.cellpadding=0;
		}
		//passing vars
		var init = new Object();
		init.struct = new Array();
		init.mother=this.mother;
		init.h=this.h;
		init.w=this.w;
		//cssExtractor
		this.cssExtractor = new htmlRender_cssExtractor(this.mother.style);
		//switch____________________________________________
		var nodeName=this.struct.firstChild.nodeName.toLowerCase();
		var childnodeName=this.struct.firstChild.firstChild.nodeName.toLowerCase();
		//________________________
		if (nodeName=="img"){
			init.struct = this.struct.firstChild;
			this.attachMovie(htmlRender_img.symbolName, "element", 1, init);
			//disable hand cursor, default not linked
			this.element.useHandCursor=false;
			//
			break;
		//________________________
		}else if (nodeName=="a" && (childnodeName!="img" || childnodeName!="div" || childnodeName!="table")){
			init.struct = this.struct.firstChild;
			//report values
			init.struct.attributes.align=this.struct.attributes.align;
			init.struct.attributes.valign=this.struct.attributes.valign;
			init.struct.attributes.height=this.struct.attributes.height;
			init.struct.attributes.width=this.struct.attributes.width;
			//recursive attachment
			this.attachMovie(htmlRender_cell.symbolName, "childCell", 1, init);
			//onRelease do action
			var href=this.struct.firstChild.attributes.href;
			var target=this.struct.firstChild.attributes.target;
			//
			if (href!=undefined){
				if (href.indexOf("asfunction")!=-1){
					var hreftemp=href.split(",");
					this.childCell.assignHref(function(){this.mother.HTFcallBack(hreftemp[1])});
				}else{
					if (target==undefined){
						target="_blank";
					}
					this.childCell.assignHref(function(){getURL(href,target)});
				}
				//set linked
				this.childCell.setLinked();
			}
			//assign href
			break;
		//________________________ CAN contain only another cell element: table,img,a,text
		}else if (nodeName=="div"){
			init.struct = this.struct.firstChild;
			//############# div attributes ##################
			//report values
			init.struct.attributes.align=this.struct.attributes.align;
			init.struct.attributes.valign=this.struct.attributes.valign;
			init.struct.attributes.height=this.struct.attributes.height;
			init.struct.attributes.width=this.struct.attributes.width;
			//css tag
			var extracted=this.cssExtractor.getCSSItem("div",init.struct);
			//css Id
			var extracted=this.cssExtractor.getCSSItem("#"+init.struct.attributes["id"],init.struct);
			//css class
			var extracted=this.cssExtractor.getCSSItem("."+init.struct.attributes["class"],init.struct);
			//
			if (init.struct.attributes.width>0){
				this.w=init.struct.attributes.width;
			}
			if (init.struct.attributes.height>0){
				this.h=init.struct.attributes.height;
			}
			//############# div attributes ##################
			//recursive attachment
			this.attachMovie(htmlRender_cell.symbolName, "childCell", 1, init);
			//assign href
			break;
		//________________________
		}else if (nodeName=="table"){
			//offset
			//this.offset=0;
			//
			init.struct = this.struct.firstChild;
			this.attachMovie(htmlRender_table.symbolName, "element", 1, init);
			//
			break;
		//________________________
		}else{
			//duplicate structure
			var cloned=new XML(this.struct.toString());
			//add superspan container
			cloned.firstChild.nodeName="span";
			//trace("cloned::"+cloned);
			init.struct=cloned;
			this.attachMovie(htmlRender_text.symbolName, "element", 1, init);
		//
		}
		//choose between this.w and this._width
		var maxw=0;
		if (Number(this.w)>this._width){
			maxw=Number(this.w);
		}else{
			maxw=this._width;
		}
		//calculate bounding box dim
		var tempw=maxw+(this.cellpadding*2);
		var temph=this._height+(this.cellpadding*2);
		//temp box to calculate cellspacing
		var drawer=new FP_drawPrimitives(this);
		drawer.drawSquare(0, 0, tempw, temph, undefined, 100, 0, 0x000000, 0);
	}
	//update cell dimension (2° step rendering)
	private function updateCellHeight(eheight:Number):Void {
		//hold heigth
		this.h=eheight;
	}
	//update cell dimension (3° step rendering)
	private function updateCellWidth(ewidth:Number):Void {
		//hold widht
		this.w=ewidth;
		//draw back
		var drawer=new FP_drawPrimitives(this);
		this.clear();
		//set up colors and border thick
		var bordercolor=0x333333;
		var borderthick=-1;
		if (Number(this.struct.attributes.border)>0) {
			borderthick=Number(this.struct.attributes.border);
			//
			if (this.struct.attributes.bordercolor!=undefined){
				bordercolor=Number("0x"+(this.struct.attributes.bordercolor).substr(1, 7));
			}
			//*****
			this.offset=borderthick;
		}
		//
		var bgcolor=undefined;
		if (this.struct.attributes.bgcolor!=undefined) {
			bgcolor=Number("0x"+(this.struct.attributes.bgcolor).substr(1, 7));
		}
		//draw box
		drawer.drawSquare(0, 0, this.w, this.h, bgcolor, 100, borderthick, bordercolor, 100, this.struct.attributes.style)
		//update content (text)
		this.element.setDim(this.w-(this.cellpadding*2),this.h-(this.cellpadding*2));
		//update element position into the cell
		this.updateElementPosition(this.w-(this.cellpadding*2),this.h-(this.cellpadding*2));
	}
	//update element position
	private function updateElementPosition(wn:Number,hn:Number):Void{
		var eh=this.element._height;
		var ew=this.element._width;
		//align
		if (this.struct.attributes.valign.toLowerCase() == "middle") {
			this.element._y =Math.round((hn/2)-Number(eh)/2)+this.cellpadding+this.offset;
		} else if (this.struct.attributes.valign.toLowerCase() == "bottom") {
			this.element._y = Math.round((hn)-Number(eh))+this.cellpadding+this.offset;
		}else{
			this.element._y = this.cellpadding+this.offset;
		}
		//
		if (this.struct.attributes.align.toLowerCase() == "center") {
			this.element._x = Math.round((wn/2)-(ew/2))+this.cellpadding+this.offset;
		} else if (this.struct.attributes.align.toLowerCase() == "right") {
			this.element._x = Math.round(wn-ew)+this.cellpadding+this.offset;
		}else{
			this.element._x = this.cellpadding+this.offset;
		}
		//recurse to childs
		this.childCell.updateElementPosition(wn+(this.cellpadding*2),hn+(this.cellpadding*2));
	}
	//assign href to child element
	public function assignHref(href:Function):Void{
		//assign a function
		this.element.onRelease=href;
	}
	//set linked status (cursor hand)
	public function setLinked():Void{
		this.element.useHandCursor=true;
	}
	//get Width used for percentages
	public function getDims():Object{
		//get width from parent (td)
		return {width:this.w,height:this.h};
	}
}
