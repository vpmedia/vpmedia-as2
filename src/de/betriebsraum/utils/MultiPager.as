/**
 * MultiPager
 *
 * @author: Felix Raab, E-Mail: f.raab@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */ 


import mx.events.EventDispatcher;


class de.betriebsraum.utils.MultiPager {
	
	
	private var dispatchEvent:Function;
	public var addEventListener:Function;
	public var removeEventListener:Function;
	
	private var container_mc:MovieClip;
	private var pages_mc:MovieClip;	
	private var prevSingle_mc:MovieClip;
	private var prevMultiple_mc:MovieClip;
	private var nextSingle_mc:MovieClip;
	private var nextMultiple_mc:MovieClip;
	
	private var totalRows:Number;
	private var displayedRows:Number;
	private var pagesVisible:Number;	
	private var totalPages:Number;
	private var activePage:Number;
	private var focusIndex:Number;
	
	private var _pageOffset:Number = 1;
	private var _buttonOffset:Number = 1;
	private var _buttonDistance:Number = 3;	
		
	
	public function MultiPager(target:MovieClip, depth:Number, x:Number, y:Number) {
		
		container_mc = target.createEmptyMovieClip("container_mc"+depth, depth);		
		container_mc._x = x;
		container_mc._y = y;		
		
		EventDispatcher.initialize(this);	
		
	}
	
	
	/***************************************************************************
	// Private Methods
	***************************************************************************/
	private function generate():Void {
		
		createPageContainer();
		
		var lastX:Number = 0;		
		var startIndex:Number = Math.min(Math.max(1, activePage-focusIndex+1), Math.max(1, totalPages-pagesVisible+1));
		var endIndex:Number = startIndex + Math.min(pagesVisible, totalPages-startIndex+1);
		
		for (var i:Number=startIndex; i<endIndex; i++) {
			
			var pageClicker:MovieClip = pages_mc.attachMovie("mc_page", "pageClicker_mc", pages_mc.getNextHighestDepth(), {_x:lastX});
			pageClicker.label = i;
			setupClicker(pageClicker);			
			lastX = pageClicker._x + pageClicker._width + _pageOffset;		
						
			if (i == activePage) setClickerActive(pageClicker);
			
			//
			var me:MultiPager = this;
			
			pageClicker.onRollOver = pageClicker.onRollOut = pageClicker.onDragOut = pageClicker.onDragOver = pageClicker.onReleaseOutside = function() {			
				me.setupClicker(this);				
			}
			
			pageClicker.onRelease = function() {
				
				me.setupClicker(this);
				me.goto(this.label);				
				
			}				
			
		}		
		
		setupPager();
		
	}	
	
	
	private function createPageContainer():Void {
		
		if (pages_mc) pages_mc.removeMovieClip();
		pages_mc = container_mc.createEmptyMovieClip("pages_mc", 0);	
		
	}
	
	
	private function setupClicker(pageClicker:MovieClip):Void {
		
		pageClicker.label_txt.autoSize = true;	
		pageClicker.label_txt.text = pageClicker.label;
		pageClicker.bg_mc._width = pageClicker.label_txt._width;
		
	}
	
	
	private function setClickerActive(pageClicker:MovieClip):Void {
		
		pageClicker.gotoAndStop("_active");
		setupClicker(pageClicker);
		pageClicker.enabled = false;
		
	}
	
	
	private function setupPager():Void {
		
		createButtons();
		arrange();
		setButtonHandler();
		
	}
	
	
	private function createButtons():Void {
		
		prevSingle_mc = container_mc.attachMovie("mc_prev_single", "prevSingle_mc", 1);		
		prevMultiple_mc = container_mc.attachMovie("mc_prev_multiple", "prevMultiple_mc", 2);
		nextSingle_mc = container_mc.attachMovie("mc_next_single", "nextSingle_mc", 3);		
		nextMultiple_mc = container_mc.attachMovie("mc_next_multiple", "nextMultiple_mc", 4);		
		
		if (activePage <= 1) {
			prevSingle_mc.gotoAndStop("_disabled");
			prevSingle_mc.enabled = false;
			prevMultiple_mc.gotoAndStop("_disabled");
			prevMultiple_mc.enabled = false;
		}
		
		if (activePage == totalPages) {
			nextSingle_mc.gotoAndStop("_disabled");
			nextSingle_mc.enabled = false;
			nextMultiple_mc.gotoAndStop("_disabled");
			nextMultiple_mc.enabled = false;
		}
		
	}
	
	
	private function arrange():Void {
		
		prevMultiple_mc._x = 0;
		prevSingle_mc._x = prevMultiple_mc._x + prevMultiple_mc._width + _buttonOffset;
		
		pages_mc._x = prevSingle_mc._x + prevSingle_mc._width + _buttonDistance;
		
		nextSingle_mc._x = pages_mc._x + pages_mc._width + _buttonDistance;
		nextMultiple_mc._x = nextSingle_mc._x + nextSingle_mc._width + _buttonOffset;		
		
	}
	
	
	private function setButtonHandler():Void {
		
		var me:MultiPager = this;		
		
		prevSingle_mc.onRelease = function() { me.onButtonClick(me.activePage - 1); };
		prevMultiple_mc.onRelease = function() { me.onButtonClick(1); };
		nextSingle_mc.onRelease = function() { me.onButtonClick(me.activePage + 1); };
		nextMultiple_mc.onRelease = function() { me.onButtonClick(me.totalPages); };
		
	}

	
	private function onButtonClick(activePage:Number):Void {				
		goto(activePage);		
	}
	
	
	private function getValidPageNumber(page:Number):Number {

		var vPage:Number = Math.min(Math.max(1, page), totalPages);
		if (isNaN(vPage)) vPage = 1;
		return vPage;
			
	}
	
	
	private function initValues(totalRows:Number, displayedRows:Number, pagesVisible:Number, activePage:Number) {
		
		this.totalRows = Math.max(0, totalRows);
		this.displayedRows = Math.max(1, displayedRows);
		this.pagesVisible = Math.max(1, pagesVisible);
		
		if (this.totalRows == 0) {
			this.displayedRows = 0;
			this.pagesVisible = 0;
			totalPages = 0;
			this.activePage = 0;
			focusIndex = 0;
		} else {
			totalPages = Math.ceil(totalRows/this.displayedRows);
			focusIndex = Math.floor(this.pagesVisible/2)+1;
			this.activePage = getValidPageNumber(activePage);
		}
		
	}
	

	/***************************************************************************
	// Public Methods
	***************************************************************************/
	public function init(totalRows:Number, displayedRows:Number, pagesVisible:Number, activePage:Number):Void {
			
		initValues(totalRows, displayedRows, pagesVisible, activePage);
		generate();
		dispatchEvent({type:"onInit", target:this, info:info});
		
	}
	
	
	public function goto(page:Number):Void {
		
		activePage = getValidPageNumber(page);
		generate();
		dispatchEvent({type:"onPageSet", target:this, info:info});	
	
	}
	
	
	public function refresh(newTotalRows:Number, activePage:Number):Void {
		
		var aPage:Number = (activePage == undefined) ? this.activePage : activePage;
		initValues(newTotalRows, displayedRows, pagesVisible, aPage);
		goto(aPage);
		
	}
	
	
	public function move(x:Number, y:Number):Void {
		
		container_mc._x = x;
		container_mc._y = y;
		
	}
	
	
	public function destroy():Void {		
		container_mc.removeMovieClip();		
	}
	
	
	/***************************************************************************
	// Getter / Setter
	***************************************************************************/
	public function get info():Object {
		
		var info:Object = new Object();
		
		info.totalRows = totalRows;
		info.displayedRows = displayedRows;
		info.pagesVisible = pagesVisible;
		info.activePage = activePage;
		info.totalPages = totalPages;		
		info.limit = (activePage-1)*displayedRows;
		info.offset = Math.min(totalRows, activePage*displayedRows)-info.limit;
		info.displayedFrom = (totalRows == 0) ? 0 : info.limit+1;
		info.displayedTo = (totalRows == 0) ? 0 : info.limit+1 + info.offset-1;
	
		return info;
		
	}
	
	
	public function get x():Number {
		return container_mc._x;
	}
	
	
	public function get y():Number {
		return container_mc._y;
	}	
	
	
	public function get width():Number {
		return container_mc._width;
	}
	
	
	public function get height():Number {
		return container_mc._height;
	}
	
	
	public function get pageOffset():Number {
		return _pageOffset;
	}
	
	public function set pageOffset(newPageOffset:Number):Void {
		_pageOffset = newPageOffset;
	}
	
	
	public function get buttonOffset():Number {
		return _buttonOffset;
	}
	
	public function set buttonOffset(newButtonOffset:Number):Void {
		_buttonOffset = newButtonOffset;
	}	
	
	
	public function get buttonDistance():Number {
		return _buttonDistance;
	}
	
	public function set buttonDistance(newButtonDistance:Number):Void {
		_buttonDistance = newButtonDistance;
	}

	
}