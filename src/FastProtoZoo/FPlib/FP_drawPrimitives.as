//###########################################################
//#### MAKO FastProtoZoo Components #########################
//#### email marcosangalli@hotmail.com ######################
//###########################################################
import FastProtoZoo.FPcloner.cloner;
//
class FastProtoZoo.FPlib.FP_drawPrimitives extends Object{
	//
	private var targetObject:MovieClip;
	//
	function FP_drawPrimitives(target:MovieClip){
		this.targetObject=target;
	}
	//#########################################################################
	//###### SQUARE
	//#########################################################################
	public function drawSquare(xorigin:Number,yorigin:Number,w:Number,h:Number,fillColor:Number,fillColorAlpha:Number,lineT:Number,lineColor:Number,lineColorAlpha:Number,lineStyle:String, dashLength:Number,spaceLength:Number):Void{
		//draw square polygon
		var points=[{x:xorigin,y:yorigin},{x:w+xorigin,y:yorigin},{x:w+xorigin,y:h+yorigin},{x:xorigin,y:h+yorigin}];
		this.drawPolygon(points,fillColor,fillColorAlpha,lineT,lineColor,lineColorAlpha,true,lineStyle, dashLength,spaceLength);
	}
	//#########################################################################
	//###### NGON
	//#########################################################################
	public function drawNGon(n:Number,xcenter:Number, ycenter:Number, radius:Number, fillColor:Number,fillColorAlpha:Number,lineT:Number,lineColor:Number,lineColorAlpha:Number,lineStyle:String,dashLength:Number,spaceLength:Number):Void {
		//
		var points:Array=new Array();
		//calculate angle
		var a=360/n;
		//
		for (var i=0;i<360;i+=a){
			//trasform into radiants
			var angle=Math.PI*i/180;
			points.push({x:xcenter+(Math.cos(angle)*radius),y:ycenter+(Math.sin(angle)*radius)});
		}
		//draw splineShape
		this.drawPolygon(points, fillColor,fillColorAlpha,lineT,lineColor,lineColorAlpha,true,lineStyle, dashLength,spaceLength);
	}
	//#########################################################################
	//###### POLYGON
	//#########################################################################
	public function drawPolygon(originalpoints:Array,fillColor:Number,fillColorAlpha:Number,lineT:Number,lineColor:Number,lineColorAlpha:Number,closed:Boolean,lineStyle:String, dashLength:Number,spaceLength:Number):Void{
		//make a copy of the points array
		var points:Array=cloner.clone(originalpoints);
		//define a default line style
		if (lineStyle==undefined){
			lineStyle="solid";
		}
		//default dashed
		if (!dashLength){
			dashLength=5;
		}
		//attach the last point
		if (closed){
			points.push(points[0]);
		}
		//fill polygon
		if(fillColor!=undefined &&  fillColorAlpha>0 && closed){
			this.targetObject.beginFill(fillColor,fillColorAlpha);
		}
		//set line if solid defined
		if (lineT>=0 && lineColorAlpha>0 && lineStyle=="solid"){
			this.targetObject.lineStyle(lineT,lineColor,lineColorAlpha);
		}else{
			this.targetObject.lineStyle();
		}
		//draw
		this.targetObject.moveTo(points[0].x,points[0].y);
		for (var i=1;i<points.length;i++){
			this.targetObject.lineTo(points[i].x,points[i].y);
		}
		this.targetObject.endFill();
		//dashed line
		if (lineStyle!="solid" && lineT>=0 && lineColorAlpha>0){
			this.targetObject.lineStyle(lineT,lineColor,lineColorAlpha);
			//create dashed outline
			for (var i=0;i<points.length-1;i++){
				this.drawLine({x:points[i].x,y:points[i].y},{x:points[i+1].x,y:points[i+1].y},lineT,lineColor,lineColorAlpha,lineStyle,dashLength,dashLength);
			}
		}
	}
	//#########################################################################
	//###### QUAD SPLINE
	//#########################################################################
	public function drawSpline(originalpoints:Array, fillColor:Number,fillColorAlpha:Number,lineT:Number,lineColor:Number,lineColorAlpha:Number,closed:Boolean,lineStyle:String, dashLength:Number,spaceLength:Number):Void {
		//make a copy of the points array
		var points:Array=cloner.clone(originalpoints);
		//define a default line style
		if (lineStyle==undefined){
			lineStyle="solid";
		}
		//default dashed
		if (!dashLength){
			dashLength=5;
		}
		//dotted
		if (lineStyle=="dotted"){
			dashLength=lineT+1;
		}
		//
		if (lineT>=0 && lineColorAlpha>0 && lineStyle=="solid"){
			this.targetObject.lineStyle(lineT,lineColor,lineColorAlpha);
		}else{
			this.targetObject.lineStyle();
		}
		//fill
		if(fillColor!=undefined &&  fillColorAlpha>0 && closed){
			this.targetObject.beginFill(fillColor,fillColorAlpha);
		}else{
			this.targetObject.beginFill();
		}
		//create quad spline points
		var anchors:Array=new Array();
		for (var i=0;i<points.length-1;i++){
			anchors.push({x:(points[i].x+points[i+1].x)/2,y:(points[i].y+points[i+1].y)/2});
		}
		//add anchors
		if (closed){
			anchors.push({x:(points[points.length-1].x+points[0].x)/2,y:(points[points.length-1].y+points[0].y)/2});
			points.push({x:points[0].x,y:points[0].y});
			this.targetObject.moveTo(anchors[anchors.length-1].x,anchors[anchors.length-1].y);
		}else{
			anchors[0]={x:points[0].x,y:points[0].y};
			anchors[anchors.length-1]={x:points[points.length-1].x,y:points[points.length-1].y};
			this.targetObject.moveTo(points[0].x,points[0].y);
		}
		//create curves
		for (var i = 0; i<anchors.length; i++) {
			this.targetObject.curveTo(points[i].x, points[i].y, anchors[i].x, anchors[i].y);
		}
		//end fill
		this.targetObject.endFill();
		// draw dashed#############
		if (lineStyle=="dashed"){
			if (closed){
				anchors.push({x:anchors[0].x,y:anchors[0].y});
			}
			//define lineStyle
			this.targetObject.lineStyle(lineT,lineColor,lineColorAlpha);
			//draw all
			for (var i = 0; i<anchors.length-1; i++) {
				//define points
				var startpoint=anchors[i];
				var endpoint=anchors[i+1];
				var controlpoint=points[i+1];
				//init vars for dashed curve
				var vxi = 2*(controlpoint.x-startpoint.x);
				var vyi = 2*(controlpoint.y-startpoint.y);
				var vxf = 2*(endpoint.x-controlpoint.x);
				var vyf = 2*(endpoint.y-controlpoint.y);
				//
				var ax = vxf-vxi;
				var ay = vyf-vyi;
				//
				var count = 0;
				var ti = 0;
				var vvX = vxi+ax*ti;
				var vvY = vyi+ay*ti;
				while (ti<1) {
					var t = dashLength/Math.sqrt(vvX*vvX+vvY*vvY);
					//
					var tf = ti+t;
					if (tf>1) {
						break;
					}
					vvX += ax*t;
					vvY += ay*t;
					var pt = {x:startpoint.x+vxi*tf+(tf*tf*ax)/2, y:startpoint.y+vyi*tf+(tf*tf*ay)/2};
					count++;
					//draw dash or nothing
					if (count%2){
						this.targetObject.moveTo(pt.x, pt.y)
					}else{
						this.targetObject.curveTo(pt.x-t*vvX/2, pt.y-t*vvY/2, pt.x, pt.y);
					}
					//
					ti = tf;
				}
			}
		}
	}
	//#########################################################################
	//###### CIRCLE
	//#########################################################################
	public function drawCircle(xcenter:Number, ycenter:Number, radius:Number, fillColor:Number,fillColorAlpha:Number,lineT:Number,lineColor:Number,lineColorAlpha:Number,lineStyle:String,dashLength:Number,spaceLength:Number):Void {
		//
		var points:Array=new Array();
		//
		for (var i=0;i<360;i+=45){
			//trasform into radiants
			var angle=Math.PI*i/180;
			points.push({x:xcenter+(Math.cos(angle)*radius),y:ycenter+(Math.sin(angle)*radius)});
		}
		//draw splineShape
		this.drawSpline(points, fillColor,fillColorAlpha,lineT,lineColor,lineColorAlpha,true,lineStyle, dashLength,spaceLength);
	};
	//#########################################################################
	//###### CLEAR
	//#########################################################################
	public function clear():Void{
		this.targetObject.clear();
	}
	//#########################################################################
	//###### DRAW LINE
	//#########################################################################
	public function drawLine(startPoint:Object,endPoint:Object,lineT:Number,lineColor:Number,lineColorAlpha:Number,lineStyle:String,dashLength:Number,spaceLength:Number){
		//
		if (lineT>=0){
			this.targetObject.lineStyle(lineT,lineColor,lineColorAlpha);
		}else{
			this.targetObject.lineStyle();
		}
		//default dashed
		if (!dashLength){
			dashLength=10;
		}
		if (!spaceLength){
			spaceLength=10;
		}
		//dotied
		if (lineStyle=="dotted"){
			dashLength=lineT+1;
		}
		//
		if (lineStyle=="dashed" || lineStyle=="dotted"){
			var x = endPoint.x - startPoint.x;
			var y = endPoint.y - startPoint.y;
			var hyp = Math.sqrt((x)*(x) + (y)*(y));
			var units = hyp/(dashLength+spaceLength);
			var dashSpaceRatio = dashLength/(dashLength+spaceLength);
			var dashX = (x/units)*dashSpaceRatio;
			var spaceX = (x/units)-dashX;
			var dashY = (y/units)*dashSpaceRatio;
			var spaceY = (y/units)-dashY;
			this.targetObject.moveTo(startPoint.x, startPoint.y);
			while (hyp > 0) {
				startPoint.x += dashX;
				startPoint.y += dashY;
				hyp -= dashLength;
				if (hyp < 0) {
					startPoint.x = endPoint.x;
					startPoint.y = endPoint.y;
				}
				this.targetObject.lineTo(startPoint.x, startPoint.y);
				startPoint.x += spaceX;
				startPoint.y += spaceY;
				this.targetObject.moveTo(startPoint.x, startPoint.y);
				hyp -= spaceLength;
			}
		}else{
			this.targetObject.moveTo(startPoint.x,startPoint.y);
			this.targetObject.lineTo(endPoint.x,endPoint.y);
		}
	}
}