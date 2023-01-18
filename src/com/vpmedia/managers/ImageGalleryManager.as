// Implementations
import com.vpmedia.xmlDataObj;
import com.vpmedia.events.Delegate;
import mx.events.EventDispatcher;
// Define Class
class com.vpmedia.managers.ImageGalleryManager extends MovieClip {
	// START CLASS
	public var className:String = "ImageGallery";
	public static var version:String = "1.0.0";
	// EventDispatcher
	public var addEventListener:Function;
	public var removeEventListener:Function;
	public var dispatchEvent:Function;
	public var dispatchQueue:Function;
	// XML Data
	private var initXML:xmlDataObj;
	// Image Loader
	private var mcl_obj:MovieClipLoader;
	private var mcl_lis:Object;
	//
	private var gContainer_mc:MovieClip;
	//
	private var gHolder_mc:MovieClip;
	//
	private var sourceDP:Object;
	private var type:String;
	private var sortList:Object;
	private var parentIndex:Number;
	private var gBigHolder_mc:MovieClip;
	private var gBigDummy_mc:MovieClip;
	//
	private var startNumber:Number;
	private var gImagePath:String;
	private var gImageNid:Number;
	private var gImageCount:Number;
	private var gImageDir:String;
	private var gImageSort:String;
	private var gThumbWidth:Number;
	private var gThumbHeight:Number;
	private var gThumbPaddingX:Number;
	private var gThumbPaddingY:Number;
	private var gThumbInitX:Number;
	private var gThumbInitY:Number;
	private var gThumbItems:Array;
	private var gThumbCountH:Number;
	private var gThumbCountV:Number;
	private var gThumbCount:Number;
	private var gThumbLoadedCount:Number;
	private var gThumbAllWidth:Number;
	private var gThumbAllHeight:Number;
	private var gThumbBgColor:Number;
	private var gTextColor:Number;
	private var isSlide:Boolean;
	private var gShowThumbTitle:Boolean;
	//
	private var dataSource = "";
	//
	// Constructor
	function ImageGalleryManager(_ref) {
		EventDispatcher.initialize(this);
		//trace (this.toString ());
		this.initGallery(_ref);
	}
	public function setTextColor(_color) {
		this.gTextColor = _color;
		var __refPager = this.gContainer_mc.pager_txt;
		var __refPrev = this.gContainer_mc.gScrollPrev_mc.label_txt;
		var __refNext = this.gContainer_mc.gScrollNext_mc.label_txt;
		__refNext.textColor = __refPrev.textColor=__refPager.textColor=this.gTextColor;
	}
	public function setHost(_host) {
		this.dataSource = _host;
	}
	public function setImageDir(_dir) {
		this.gImageDir = _dir;
	}
	public function setImageSort(_sort) {
		this.gImageSort = _sort;
		//ByName,BySize,ByTime,ByType
	}
	/**
	 * <p>Description: toString</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString():String {
		return ("["+className+"]");
	}
	/**
	 * <p>Description: SetDimension</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function setShowLabel(isShow) {
		this.gShowThumbTitle = isShow;
	}
	public function setDimension(__countH:Number, __countV:Number, __w:Number, __h:Number, __x:Number, __y:Number, __padX:Number, __padY:Number, __isSlide:Boolean):Void {
		this.isSlide = __isSlide;
		!__countV ? __countV=1 : null;
		!__countH ? __countH=1 : null;
		!__w ? __w=100 : null;
		!__h ? __h=100 : null;
		!__x ? __x=0 : null;
		!__y ? __y=0 : null;
		!__padX ? __padX=3 : null;
		!__padY ? __padY=3 : null;
		//
		this.gThumbWidth = __w;
		this.gThumbHeight = __h;
		this.gThumbCountH = __countH;
		this.gThumbCountV = __countV;
		this.gThumbPaddingX = __padX;
		this.gThumbPaddingY = __padY;
		this.gThumbInitX = __x;
		this.gThumbInitY = __y;
		this.gThumbCount = this.gThumbCountH*this.gThumbCountV;
		this.gThumbAllWidth = (this.gThumbWidth*this.gThumbCountH)+(this.gThumbPaddingX*this.gThumbCountH);
		this.gThumbAllHeight = (this.gThumbHeight*this.gThumbCountV)+(this.gThumbPaddingY*this.gThumbCountV);
		this.setPagerPos();
	}
	/**
	 * <p>Description: InitGallery</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function initGallery(__gContainer:MovieClip):Void {
		this.setGalleryContainer(__gContainer);
		this.createGalleryHolder();
		this.initMcLoader();
		this.setDimension();
		this.createPager();
	}
	/**
	 * <p>Description: setGalleryContainer</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function setGalleryContainer(__gContainer) {
		this.gContainer_mc = __gContainer;
	}
	/**
	 * <p>Description: createGalleryHolder</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function createGalleryHolder() {
		this.gContainer_mc.createEmptyMovieClip("gHolder_mc", this.getNextHighestDepth());
	}
	/**
	 * <p>Description: DeleteGallery</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function deleteGallery() {
		this.gContainer_mc.gBigDummy_mc.removeMovieClip();
		this.gContainer_mc.gBigHolder_mc.removeMovieClip();
		this.gContainer_mc.gHolder_mc.removeMovieClip();
		this.createGalleryHolder();
	}
	/**
	 * <p>Description: CreateGallery</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function startGallery(__sourceDP, __startNum, __parentIndex) {
		this.startNumber = __startNum;
		var __itemCounter:Number = 1;
		var __itemPageCounter:Number = 1;
		var __xCount:Number = 0;
		var __yCount:Number = 0;
		var __currPageCount = Number(this.startNumber/this.gThumbCount)+1;
		var __lastPageCount = Math.ceil((__sourceDP[__parentIndex].fileCount+__sourceDP[__parentIndex].dirCount)/this.gThumbCount);
		__lastPageCount<1 ? __lastPageCount = 1 : "";
		var __str = __currPageCount+"/"+__lastPageCount;
		// set Pager
		this.gContainer_mc.pager_txt.text = __str;
		this.gImageCount = __sourceDP[__parentIndex].fileCount+__sourceDP[__parentIndex].dirCount;
		//
		if (this.gThumbCountH == 1 && this.isSlide) {
			this.gThumbCount = this.gImageCount;
			this.gThumbCountH = this.gImageCount;
		}
		if (this.gThumbCountV == 1 && this.isSlide) {
			this.gThumbCount = this.gImageCount;
			this.gThumbCountV = this.gImageCount;
		}
		// Create thumbnails                        
		for (var i = 1; i<=this.gThumbCount; i++) {
			var __n:String = "thumb"+i.toString();
			var __cT = this.gContainer_mc.gHolder_mc.createEmptyMovieClip(__n, this.gContainer_mc.gHolder_mc.getNextHighestDepth());
			__cT._x = Math.abs(__xCount*(this.gThumbWidth+this.gThumbPaddingX));
			__cT._y = Math.abs(__yCount*(this.gThumbHeight+this.gThumbPaddingY));
			__cT.createEmptyMovieClip("pic_holder_mc", __cT.getNextHighestDepth());
			__cT.createEmptyMovieClip("pic_mask_mc", __cT.getNextHighestDepth());
			var __mask_mc:MovieClip = __cT.pic_mask_mc;
			__mask_mc.beginFill(0x000000, 100);
			__mask_mc.moveTo(0, 0);
			__mask_mc.lineTo(this.gThumbWidth, 0);
			__mask_mc.lineTo(this.gThumbWidth, this.gThumbHeight);
			__mask_mc.lineTo(0, this.gThumbHeight);
			__mask_mc.lineTo(0, 0);
			__mask_mc.endFill();
			// create bg
			__mask_mc.duplicateMovieClip("bg_mc", -1);
			__cT.bg_mc._width = this.gThumbWidth;
			__cT.bg_mc._height = this.gThumbHeight;
			__cT.bg_mc.colorTo(this.gThumbBgColor, 0);
			// create text
			// loader text
			__cT.createTextField("pctLoaded_txt", __cT.getNextHighestDepth(), 3, this.gThumbHeight-18, this.gThumbWidth-3, 20);
			// text format
			var my_fmt:TextFormat = new TextFormat();
			my_fmt.align = "center";
			my_fmt.font = "Arial";
			my_fmt.size = 10;
			// text object
			__cT.pctLoaded_txt.align="center";
			__cT.pctLoaded_txt.multiline = false;
			//__cT.pctLoaded_txt.autoSize = true;
			__cT.pctLoaded_txt.embedFonts = false;
			__cT.pctLoaded_txt.textColor = this.gTextColor;
			__cT.pctLoaded_txt.selectable = false;
			// init text
			__cT.pctLoaded_txt.text = "";
			// apply text format
			__cT.pctLoaded_txt.setNewTextFormat(my_fmt);
			//
			__xCount++;
			// row count
			if (__xCount == this.gThumbCountH) {
				__xCount = 0;
				__yCount += 1;
			}
			// next pageItem count                                                                                                                                                                                                                                                                                                                                                 
			__itemPageCounter++;
			// next item count                                                                                                                                                                                                
			__itemCounter++;
		}
				//
		trace(this);
		/*trace("-horizontal count: "+this.gThumbCountH);
		trace("-vertical count: "+this.gThumbCountV);
		trace("-thumb count: "+this.gThumbCount);
		trace("-image count: "+this.gImageCount);
		trace("-all width: "+this.gThumbAllWidth);
		trace("-all height "+this.gThumbAllHeight);
		trace("-current page: "+__currPageCount);
		trace("-all page "+__lastPageCount);*/
	}
	public function createGallery(__sourceDP, __startNum, __type, __sortList, __parentIndex) {
		//trace("createGallery");
		//trace("-sourceDP:"+__sourceDP);
		//trace("-startNum:"+__startNum);
		//trace("-type:"+__type);
		//trace("-sortList:"+__sortList);
		//trace("-parentIndex:"+__parentIndex);
		this.gImagePath = this.gImageDir;
		this.sourceDP = __sourceDP;
		this.type = __type;
		this.sortList = __sortList;
		this.parentIndex = __parentIndex;
		startGallery(__sourceDP, __startNum, __parentIndex);
		var __itemCounter:Number = 1;
		var __itemPageCounter:Number = 1;
		// set Gallery Content Number
		this.gThumbLoadedCount = 0;
		this.gThumbItems = new Array();
		this.gContainer_mc.gHolder_mc._x = this.gThumbInitX;
		this.gContainer_mc.gHolder_mc._y = this.gThumbInitY;
		var tmp_dp = {};
		if (typeof (__sortList) == "object") {
			for (var ind in __sortList) {
				tmp_dp[__sortList[ind]] = __sourceDP[__sortList[ind]];
			}
		} else {
			for (var ind in __sourceDP) {
				tmp_dp[ind] = __sourceDP[ind];
			}
		}
		for (var i in tmp_dp) {			
			//trace(__itemPageCounter +"/"+ this.gThumbCount +" , " + __itemCounter +"/"+ this.gImageCount);
			if (__itemCounter>this.startNumber && __sourceDP[i].type == __type && i != 0) {
				// generate name
				var __n:String = "thumb"+__itemPageCounter.toString();
				// create movie clip
				var __cT = this.gContainer_mc.gHolder_mc[__n];
				__cT.indexDP = i;
				// create buttons
				__cT.onRelease = Delegate.create(this, this.onThumbClick, __cT.indexDP);
				__cT.onRollOver = Delegate.create(this, this.onThumbRollOver, __cT.pic_holder_mc);
				__cT.onRollOut = Delegate.create(this, this.onThumbRollOut, __cT.pic_holder_mc);
				var __url;
				if (__sourceDP[i].type == "file") {
					__url = gImageDir+__sourceDP[__parentIndex].name+"/tn_"+__sourceDP[i].name;
					//__url = this.gImagePath+"tn_"+__sourceDP[i].name;
				} else {
					var firstItemIndex = __sourceDP[i].indexedByName[0];
					__url = gImageDir+__sourceDP[i].name+"/tn_"+__sourceDP[firstItemIndex].name;
					//__url = __sourceDP[firstItemIndex].dir+"/tn_"+__sourceDP[firstItemIndex].name;
				}
				this.gThumbItems.push({url:__url, target:__cT.pic_holder_mc});
				// page count				
				//trace(i+"::"+__n+"::"+__url+"::"+__itemCounter+"::"+__itemPageCounter+"/"+this.gThumbCount+"::"+this.gImageCount);
				if (__itemPageCounter == this.gThumbCount || __itemPageCounter == this.gImageCount || __itemCounter == this.gImageCount) {
					// load first thumbnail and big image
					this.mcl_obj.loadClip(this.gThumbItems[0].url, this.gThumbItems[0].target);
					//this.loadPic (this.gThumbItems[0].url.split ("tn_").join (""));
					break;
				}
				// next pageItem count                                                                                                                                                                                                                                                                                                                                                 
				__itemPageCounter++;
			}
			if (__sourceDP[i].type == __type && i != 0) {				
				// next item count                                                                                                                                                                                                                                              
				__itemCounter++;
			}

		}
	}
	public function setThumbBgColor(__color) {
		this.gThumbBgColor = __color;
	}
	/**
	 * <p>Description: Create Pager</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function createPager() {
		this.createPagerLeft();
		this.createPagerRight();
		this.createPagerButton();
		this.createPagerTextField();
		//hidePager();
	}
	/**
	 * <p>Description: Make Pager Button</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function createPagerButton() {
		// Button
		var __refPrev = this.gContainer_mc.gScrollPrev_mc;
		var __refNext = this.gContainer_mc.gScrollNext_mc;
		__refPrev.onPress = Delegate.create(this, this.prevPage);
		__refNext.onPress = Delegate.create(this, this.nextPage);
		__refPrev.onRollOver = Delegate.create(this, this.onThumbRollOver, __refPrev.label_txt);
		__refPrev.onRollOut = Delegate.create(this, this.onThumbRollOut, __refPrev.label_txt);
		__refNext.onRollOver = Delegate.create(this, this.onThumbRollOver, __refNext.label_txt);
		__refNext.onRollOut = Delegate.create(this, this.onThumbRollOut, __refNext.label_txt);
	}
	private function showPager() {
		var __refPrev = this.gContainer_mc.gScrollPrev_mc;
		var __refNext = this.gContainer_mc.gScrollNext_mc;
		var __refText = this.gContainer_mc.pager_txt;
		__refPrev._visible = __refNext._visible=__refText._visible=true;
	}
	private function hidePager() {
		var __refPrev = this.gContainer_mc.gScrollPrev_mc;
		var __refNext = this.gContainer_mc.gScrollNext_mc;
		var __refText = this.gContainer_mc.pager_txt;
		__refPrev._visible = __refNext._visible=__refText._visible=false;
	}
	/**
	 * <p>Description: Create Pager Left and Right</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function createPagerLeft() {
		// pagePrev
		var __o:Object = this.getPagerLeftPos();
		this.gContainer_mc.attachMovie("gScrollPrev_mc", "gScrollPrev_mc", this.gContainer_mc.getNextHighestDepth(), __o);
	}
	private function createPagerRight() {
		// pageNext
		var __o:Object = getPagerRightPos();
		this.gContainer_mc.attachMovie("gScrollNext_mc", "gScrollNext_mc", this.gContainer_mc.getNextHighestDepth(), __o);
	}
	/**
	 * <p>Description: Get Pager Left and Right Position</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function getPagerLeftPos() {
		var __o:Object = new Object();
		__o._x = this.gThumbInitX;
		__o._y = this.gThumbInitY+this.gThumbAllHeight+10;
		__o._visible = true;
		return __o;
	}
	private function getPagerRightPos() {
		var __o:Object = new Object();
		__o._x = this.gThumbInitX+this.gThumbAllWidth-20;
		__o._y = this.gThumbInitY+this.gThumbAllHeight+10;
		__o._visible = true;
		return __o;
	}
	/**
	 * <p>Description: Set Pager Left and Right Position</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function setPagerLeftPos() {
		var __o:Object = this.getPagerLeftPos();
		this.gContainer_mc.gScrollPrev_mc._x = __o._x;
		this.gContainer_mc.gScrollPrev_mc._y = __o._y;
	}
	private function setPagerRightPos() {
		var __o:Object = this.getPagerRightPos();
		this.gContainer_mc.gScrollNext_mc._x = __o._x;
		this.gContainer_mc.gScrollNext_mc._y = __o._y;
	}
	private function setPagerPos() {
		this.setPagerLeftPos();
		this.setPagerRightPos();
		this.resizePagerTextField();
	}
	/**
	 * <p>Description: Set Pager Textfield Position</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function resizePagerTextField() {
		var __refPrev = this.gContainer_mc.gScrollPrev_mc;
		var __refNext = this.gContainer_mc.gScrollNext_mc;
		var __w = this.gThumbAllWidth;
		this.gContainer_mc.pager_txt._width = __w;
		this.gContainer_mc.pager_txt._x = __refPrev._x;
		this.gContainer_mc.pager_txt._y = __refPrev._y-3;
	}
	/**
	 * <p>Description: Create Pager Textfield</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function createPagerTextField() {
		var __refPrev = this.gContainer_mc.gScrollPrev_mc;
		var __refNext = this.gContainer_mc.gScrollNext_mc;
		//
		var __x = __refPrev._x;
		var __y = __refPrev._y-3;
		var __w = this.gThumbAllWidth;
		var __h = 20;
		//trace ("-x:" + __x + "\n-y:" + __y + "\n-w:" + __w + "\n-h:" + __h);
		this.gContainer_mc.createTextField("pager_txt", this.gContainer_mc.getNextHighestDepth(), __x, __y, __w, __h);
		var __refText = this.gContainer_mc.pager_txt;
		//
		var my_fmt:TextFormat = new TextFormat();
		my_fmt.align = "center";
		my_fmt.font = "Arial";
		my_fmt.size = 10;
		//
		__refText.align = "center";
		__refText.multiline = false;
		__refText.embedFonts = false;
		__refText.textColor = this.gTextColor;
		__refText.selectable = false;
		//
		__refText.setNewTextFormat(my_fmt);
		__refText.text = "loading..";
	}
	function onGalleryLoad() {
		this.dispatchEvent({type:"onPageLoad", target:this});
		this.dispatchEvent({type:"onThumbClick", target:this, idx:this.gContainer_mc.gHolder_mc.thumb1.indexDP});
		this.showPager();
		//if (this.gThumbCount >= this.gImageCount) {		
		//}
		if (this.isSlide) {
			this.gContainer_mc.onEnterFrame = function() {
				//trace(this.gHolder_mc._ymouse>0 && this.gHolder_mc._ymouse<this.gHolder_mc._height);
				if (this.gHolder_mc._ymouse) {
					this.gHolder_mc._x += (this.gHolder_mc._x+(this.gHolder_mc._xmouse-Stage.width/2))/10*0.3;
					if (this.gHolder_mc._x<Stage.width-this.gHolder_mc._width) {
						this.gHolder_mc._x = Stage.width-this.gHolder_mc._width;
					}
					if (this.gHolder_mc._x>0) {
						this.gHolder_mc._x = 0;
					}
				}
			};
		}
	}
	/**
	 * <p>Description: RollOverOut</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function onThumbClick(indexDP) {
		this.dispatchEvent({type:"onThumbClick", target:this, idx:indexDP});
	}
	public function onThumbRollOver(__mc) {
		__mc.contrastTo(150);
		__mc.colorTransformTo(100, 100, 100, 100, 100, 100, 100, 100);
	}
	public function onThumbRollOut(__mc) {
		__mc.contrastTo(100);
	}
	/**
	 * <p>Description: Get Prev-Next Page</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function prevPage() {
		if (this.startNumber-this.gThumbCount>-1) {
			this.deleteGallery();
			this.startNumber -= this.gThumbCount;
			this.createGallery(this.sourceDP, this.startNumber, this.type, this.sortList, this.parentIndex);
		}
	}
	public function nextPage() {
		if (this.startNumber+this.gThumbCount<this.gImageCount) {
			this.deleteGallery();
			this.startNumber += this.gThumbCount;
			this.createGallery(this.sourceDP, this.startNumber, this.type, this.sortList, this.parentIndex);
		}
	}
	/**
	 * <p>Description: MovieClipLoader</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	private function onEventThumbLoad(target_mc) {
		this.dispatchEvent({type:"onThumbLoad", target:this, mc:target_mc});
		target_mc._parent.pic_holder_mc.setMask(target_mc._parent.pic_mask_mc);
		target_mc._parent.pic_holder_mc._x = (target_mc._parent.bg_mc._width-target_mc._parent.pic_holder_mc._width)/2;
		target_mc._parent.pic_holder_mc._y = (target_mc._parent.bg_mc._height-target_mc._parent.pic_holder_mc._height)/2;
		//target_mc._parent.alphaTo (100, 1);
		target_mc._parent.pic_mask_mc._yscale = 0;
		target_mc._parent.pic_mask_mc.tween("_yscale", 100, 1);
		if (this.gShowThumbTitle) {
			var tf = new TextFormat();
			tf.bold = true;
			tf.size = 12;
			tf.color = 0xff0000;
			target_mc._parent.pctLoaded_txt._y -= 6;
			target_mc._parent.pctLoaded_txt.setNewTextFormat(tf);
			target_mc._parent.pctLoaded_txt.text = sourceDP[target_mc._parent.indexDP].name.toUpperCase();
		} else {
			target_mc._parent.pctLoaded_txt.text = "";
		}
		//
		this.gThumbLoadedCount++;
		//
		var url = this.gThumbItems[this.gThumbLoadedCount].url;
		var target = this.gThumbItems[this.gThumbLoadedCount].target;
		this.mcl_obj.loadClip(url, target);
		//
		//trace(this.gThumbLoadedCount+"/"+this.gThumbCount);
		if (this.gThumbLoadedCount == this.gThumbCount || this.gThumbLoadedCount == this.gImageCount) {
			this.onGalleryLoad();
		}
		//target_mc._parent.slideTo (target_mc._parent.cX, target_mc._parent.cY, target_mc._parent.nid/5);                                                                                                  
	}
	private function initMcLoader() {
		// first set of listeners
		this.mcl_obj = new MovieClipLoader();
		this.mcl_lis = new Object();
		this.mcl_lis.onLoadStart = function(target_mc:MovieClip) {
			//trace ("onLoadStart:" + target_mc._parent);
		};
		this.mcl_lis.onLoadProgress = function(target_mc:MovieClip, loadedBytes:Number, totalBytes:Number) {
			//trace ("onLoadProgress:" + target_mc._parent);
			var pctLoaded:Number = Math.round(loadedBytes/totalBytes*100);
			if (pctLoaded>=0 && pctLoaded<=100) {
				//trace (pctLoaded);
				target_mc._parent.pctLoaded_txt.text = pctLoaded;
				// pctLoaded + "%";
			}
		};
		this.mcl_lis.onLoadComplete = function(target_mc:MovieClip) {
			//trace ("onLoadComplete:" + target_mc._parent);
			var loadProgress:Object = mcl_obj.getProgress(target_mc);
		};
		this.mcl_lis.onLoadInit = Delegate.create(this, this.onEventThumbLoad);
		/*this.mcl_lis.onLoadInit = function (target_mc:MovieClip)
		{
		//trace ("onLoadInit:" + target_mc._parent);
		
		};*/
		this.mcl_lis.onLoadError = function(target_mc:MovieClip, errorCode:String) {
			trace("** onLoadError **");
			trace("ERROR CODE = "+errorCode);
			trace("Your load failed on movie clip = "+target_mc+"\n");
		};
		this.mcl_obj.addListener(this.mcl_lis);
	}
	// END CLASS
}
