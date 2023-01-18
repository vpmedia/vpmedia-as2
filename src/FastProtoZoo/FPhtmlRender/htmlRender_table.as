//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPlib.FP_drawPrimitives;
import FastProtoZoo.FPhtmlRender.*;
//
class FastProtoZoo.FPhtmlRender.htmlRender_table extends MovieClip {
	//############ ATTACH ON THE FLY ###############################################
	static var symbolName:String = "__Packages.FastProtoZoo.FPhtmlRender.htmlRender_table";
	static var symbolOwner:Function = FastProtoZoo.FPhtmlRender.htmlRender_table;
	static var symbolLinked:Object = Object.registerClass(symbolName, symbolOwner);
	//############ ATTACH ON THE FLY ###############################################
	private var xpos, ypos:Number;
	private var mother:Object;
	private var struct:Array;
	private var cssExtractor:htmlRender_cssExtractor;
	private var w,h:Number;
	//
	function htmlRender_table() {
		//cssExtractor
		this.cssExtractor = new htmlRender_cssExtractor(this.mother.style);
		//init vars
		this.xpos = 0;
		this.ypos = 0;
		//prepare dimensions for percentage calculations
		var dims=this.getDims();
		this.w=dims.width;
		this.h=dims.height;
		//############# table attributes ##################
		var cellspacing = 0;
		var cellpadding = 0;
		//cellspacing cellpadding
		if (this.struct.attributes.cellspacing != undefined) {
			cellspacing = Number(this.struct.attributes.cellspacing);
		}
		if (this.struct.attributes.cellpadding != undefined) {
			cellpadding = Number(this.struct.attributes.cellpadding);
		}
		//css tag
		var extracted=this.cssExtractor.getCSSItem("table",this.struct);
		//css class
		var extracted=this.cssExtractor.getCSSItem("#"+this.struct.attributes["id"],this.struct);
		//css class
		var extracted=this.cssExtractor.getCSSItem("."+this.struct.attributes["class"],this.struct);
		//############# table attributes ##################
		//define a td width holder
		var tdwidth = new Array();
		//structure array
		var a:Array = new Array();
		a = this.struct.childNodes;
		//tr add cellspacing
		this.ypos += cellspacing;
		//global counter
		var counter=0;
		//
		//count max td/th------------------------------
		var cols=0;
		var maxcols=0;
		var rows=0;
		//colspan
		var span=0;
		//--------------------------------------------
		//
		//loop throught the tr and td tags, ignore others like script etc....
		for (var i = 0; i<a.length; i++) {
			if (a[i].nodeName.toLowerCase() == "tr") {
				//reset cols counter
				cols=0;
				//initial position + cellspacing
				this.xpos = 0+cellspacing;
				//temp array for td
				var b:Array = new Array();
				b = a[i].childNodes;
				//check the y coordinates assign the temp coordinates to ypos
				var ypostemp = 0;
				//search if there are td
				for (var j = 0; j<b.length; j++) {
					//type
					var objtype=b[j].nodeName.toLowerCase();
					if (objtype == "td" || objtype == "th") {
						//############# td/th attributes ##################
						if (this.struct.attributes.border != undefined && b[j].attributes.border == undefined) {
							b[j].attributes.border = this.struct.attributes.border;
						}
						if (this.struct.attributes.bordercolor != undefined && b[j].attributes.bordercolor == undefined) {
							b[j].attributes.bordercolor = this.struct.attributes.bordercolor;
						}
						//############# tr attributes ##################
						//css tag
						var extracted=this.cssExtractor.getCSSItem("tr",b[j]);
						//css class
						var extracted=this.cssExtractor.getCSSItem("#"+a[i].attributes["id"],b[j]);
						//css class
						var extracted=this.cssExtractor.getCSSItem("."+a[i].attributes["class"],b[j]);
						//############# td/th attributes ##################
						//css tag
						var extracted=this.cssExtractor.getCSSItem(objtype,b[j]);
						//css class
						var extracted=this.cssExtractor.getCSSItem("#"+b[j].attributes["id"],b[j]);
						//css class
						var extracted=this.cssExtractor.getCSSItem("."+b[j].attributes["class"],b[j]);
						//**************************************************************************************
						//overwrite width and height if defined in percentages
						var tww=b[j].attributes.width.toString();

						//
						if (tww.indexOf("%")!=-1 && tww!=undefined && this.w>0){
							var tw=tww.split("%");
							var twt=Math.round(tw[0]*(this.w/100));
							b[j].attributes.width=twt;
						}
						//overwrite width and height if defined in percentages
						var thh=b[j].attributes.height.toString();
						//
						if (thh.indexOf("%")!=-1 && thh!=undefined && this.h>0){
							var th=thh.split("%");
							var tht=Math.round(th[0]*(this.h/100));
							b[j].attributes.height=tht;
						}
						//**************************************************************************************
						//############# td/th attributes ##################
						//increment z counter
						counter++;
						//take the previous heigth and modify the xml node
						if (Number(b[j].attributes.height)<ypostemp) {
							b[j].attributes.height = ypostemp;
						}
						//calculate and assign the width buffer for the first row
						if (i == 0) {
							tdwidth.push(Number(b[j].attributes.width));
						} else {
							b[j].attributes.width = tdwidth[j];
						}
						//#################create init object and attach a new cell
						var init = new Object();
						init.struct = new Array();
						init.struct = b[j];
						init.cellpadding=cellpadding;
						init._y = this.ypos;
						init.mother=this.mother;
						this.attachMovie(htmlRender_cell.symbolName, "c"+i+"_"+(j+span), counter, init);
						//#################create init object and attach a new cell
						//
						//retrieve the right heigth from the cell
						if (ypostemp<this["c"+i+"_"+j]._height) {
							ypostemp = Math.round(this["c"+i+"_"+(j+span)]._height);
						}
						//retrieve the right width from the cell
						if (tdwidth[j]<this["c"+i+"_"+j]._width) {
							tdwidth[j] = Math.round(this["c"+i+"_"+(j+span)]._width);
						}
						//jumper>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
						if (b[j].attributes.colspan!=undefined){
							var jump=Number(b[j].attributes.colspan);
							span=(jump-1);
						}else{
							//increment cols
							cols++;
							span=0;
						}
					}
				}
				//hold max cols number
				if (maxcols<cols){
					maxcols=cols;
				}
				//refresh position for next row
				this.ypos += ypostemp+cellspacing;
				//update cell height adjusting the height
				for (var k = 0; k<=b.length; k++) {
					this["c"+i+"_"+k].updateCellHeight(ypostemp);
				}
			}
			//increment rows
			rows++;
		}
		//update cell width adjusting the width
		for (var i = 0; i<rows; i++) {
			//init tempx
			var tempx=cellspacing;
			//var jholder
			var jholder=0;
			var wolder=0;
			//iterate and modify x position and width
			for(var j = 0; j<maxcols; j++) {
				//update position
				var cell=this["c"+i+"_"+j];
				//
				if (cell!=undefined){
					//add
					if (j!=0){
						tempx+=tdwidth[j-1]+cellspacing;
					}
					//if there is a colspan after
					var cellposx=0;
					var cellwidth=0;
					if (jholder<(j-1)){
						//update prev position cell
						var prevcell=this["c"+i+"_"+jholder];
						prevcell.updateCellWidth(wolder-cellspacing);
					}
					//update width and position
					cell.updateCellWidth(tdwidth[j]);
					cell._x=tempx;
					//holders
					jholder=j;
					wolder=tdwidth[j]+cellspacing;
				}else{
					//used as debug and colspan
					if (j!=0){
						tempx+=tdwidth[j-1]+cellspacing;
					}
					wolder+=tdwidth[j]+cellspacing;
					//if it is the last cell
					if (j+1>=maxcols){
						//update prev position cell
						var prevcell=this["c"+i+"_"+jholder];
						prevcell.updateCellWidth(wolder-cellspacing);
					}
				}
			}
		}
		//total table width
		this.xpos=0;
		for (var i=0;i<tdwidth.length;i++){
			this.xpos+=tdwidth[i]+cellspacing;
		}
		this.xpos+=cellspacing;
		//set up colors and border attribs
		var bordercolor=0x333333;
		var borderthick=-1;
		if (Number(this.struct.attributes.border)>0) {
			borderthick=Number(this.struct.attributes.border);
			//
			if (this.struct.attributes.bordercolor!=undefined){
					bordercolor=Number("0x"+(this.struct.attributes.bordercolor).substr(1, 7));
			}
		}
		//
		var bgcolor=undefined;
		if (this.struct.attributes.bgcolor!=undefined) {
			bgcolor=Number("0x"+(this.struct.attributes.bgcolor).substr(1, 7));
		}
		//draw box
		var drawer=new FP_drawPrimitives(this);
		drawer.drawSquare(0, 0, this.xpos, this.ypos, bgcolor, 100, borderthick, bordercolor, 100, this.struct.attributes.style);
	}
	//get Width used for percentages from parent
	public function getDims():Object{
		var wt=this.struct.attributes.width.toString();
		var ht=this.struct.attributes.height.toString();
		//
		var dims=this._parent.getDims();
		//
		if (wt!=undefined && wt.indexOf("%")!=-1){
			var temp=wt.split("%");
			var tempt=Math.round(temp[0]*(dims.width/100));
			wt=tempt;
		}else if(wt==undefined || !(wt>0)){
			wt=100;
		}
		if (ht!=undefined && ht.indexOf("%")!=-1){
			var temp=ht.split("%");
			var tempt=Math.round(temp[0]*(dims.height/100));
			ht=tempt;
		}else if(ht==undefined || !(ht>0)){
			ht=100;
		}
		//
		var obj={width:Number(wt),height:Number(ht)};
		return(obj);
	}
}
