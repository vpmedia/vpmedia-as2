class GridArranger {
	//class variables, left x and y as public, but they could be turned private as well
	public var xSt:Number;//starting x position
	public var ySt:Number;//starting y position
	public var pCliplist:Array;//clip list to be sorted, left public to allow for calls of splice and change from other classes
	private var pCols:Number;//keeps track of number of columns if horizontal, number of rows if vertical
	private var pSpacing:Number;//spacing between items
	private var pDirection:String;//figures direction of arrange
	private var pColDir:String;//opposite of pDirection/ sets cols or rows depending on alignment
	public var pMoveDir:String; //gets the x or y direction to move set.
	private var prevCol:Array=new Array(); //tracks the previous column for spacing issues.
	private var ipr:Number;  //items per row
	//constructor function
	function GridArranger(l:Array, sp:Number, d:String, c:Number, x:Number, y:Number) {
		if (x) {//check for x value
			xSt = x;
		} else {
			xSt = 0;
		}
		if (y) {//check for y value
			ySt = y;
		} else {
			ySt = 0;
		}
		if (c) {//check for c value
			pCols = c;
		} else {
			pCols = 1;
		}
		if (sp == undefined || sp == null) {//check for sp value
			pSpacing = 0;
		} else {
			pSpacing = sp;
		}
		if (l) {//check for l value
			pCliplist = l;
		} else {
			pCliplist = new Array();
		}
		if (d == "h") {//check for d value, vertical is the default
			pDirection = "_width";
			pColDir = "_height";
			pMoveDir = "_x";
		} else {
			pDirection = "_height";
			pColDir = "_width";
			pMoveDir = "_y";
		}
	}
	public function set x(x:Number):Void {
		//setter and getters for x starting position
		xSt = x;
	}
	public function get x():Number {
		return xSt;
	}
	public function set y(y:Number):Void {
		//setter and getters for y starting position
		ySt = y;
	}
	public function get y():Number {
		return ySt;
	}
	public function set cols(c:Number):Void {
		//setter and getters for cols
		pCols = c;
	}
	public function get cols():Number {
		return pCols;
	}
	public function set cliplist(l:Array):Void {
		//setter and getters for cliplist
		pCliplist = l;
	}
	public function get cliplist():Array {
		return pCliplist;
	}
	public function set spacing(sp:Number):Void {
		//setters and getters for spacing
		pSpacing = sp;
	}
	public function get spacing():Number {
		return pSpacing;
	}
	//setters and getters for direction
	public function set direct(d:String):Void {
		if (d == "h") {
			//check for d value, vertical is the default
			pDirection = "_width";
			pColDir = "_height";
			pMoveDir = "_x";
		} else {
			pDirection = "_height";
			pColDir = "_width";
			pMoveDir = "_y";
		}
	}
	public function get direct():String {
		return pDirection;
	}
	public function get prop():String {
		return pMoveDir;
	}
	//METHODS for GridArranger class
	public function arrange(list:Array):Void {
		if (!list) {
			list = pCliplist;
		}
		//figure out the items per row for arrangement;
		ipr=Math.round(list.length/pCols);
		var tempCk=0;
		var tempNext=ipr;
		var tx = xSt;
		var ty = ySt;
		// set the first one. prevents double test for i==0.
		list[0]._x = tx;
		list[0]._y = ty;
		prevCol=[];
		prevCol.push(list[0][pColDir]);
		for (var i = 1; i<list.length; i++) {
			tempCk++;
			// bump y & reset x when crossing column boundry
			if (pDirection == "_width") {
				if (tempNext!=tempCk || tempCk>=pCols*ipr) {
					tx = list[i-1][pMoveDir]+list[i-1][pDirection]+pSpacing;
					prevCol.push(list[i][pColDir]);
					prevCol.sort(18);
					
				} else {
					tx = xSt;
					tempNext+=ipr;
					//prevCol.push(list[i][pColDir]);
					prevCol.sort(18);
					ty += prevCol[0]+pSpacing//list[i-1][pColDir]+spacing;
					prevCol=[];
					prevCol.push(list[i][pColDir]);
				}
			} else {
				
				if (tempNext!=tempCk || tempCk>=pCols*ipr) {
					ty += list[i-1][pDirection]+pSpacing;//list[i-1][pMoveDir]
					prevCol.push(list[i][pColDir]);
					prevCol.sort(18);
					
				} else {
					ty = ySt;
					tempNext+=ipr;
					//prevCol.push(list[i][pColDir]);
					prevCol.sort(18);
					
					tx += prevCol[0]+pSpacing;//list[i-1][pColDir]+spacing;
					prevCol=[];
					prevCol.push(list[i][pColDir]);
				}
			}
			
			list[i]._x = tx;
			list[i]._y = ty;
		}
	}
	public function addclip(clip:MovieClip):Array {
		pCliplist.push(clip);
		return pCliplist;
	}
}
