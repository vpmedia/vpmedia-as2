/*=====================================================
LoadQueueManager
var myLoadQueManager:LoadQueueManager = new LoadQueueManager();
var myLoadItemID:Number = myLoadQueManager.load(targetObject, URL, [listenerObject]);
myLoadQueManager.addListener(listenerObject);

=====================================================
Date: 2006/03/13
Author: Dave.m.Williamson
WWW: blog.bittube.com
=====================================================
Version: 0.0.91
=====================================================
*	fixed typo in the removeMovirClipLoader function to removeMovieClipLoader, although this was a tempory solution
	i felt it was best to fix. Ideally this function would not be a public operation.

	
=====================================================
Date: 2006/03/13
Author: Dave.m.Williamson
WWW: blog.bittube.com
=====================================================
Version: 0.0.9
=====================================================
*	added this version and change text
*	added non loading 'addItem' and "addItemAt" methods that inser object into the load queue	but wont start it loading
*	added loadQueueManager.start() method to start the loadqueue following population using addItem() and addItemAt() methods
*	added an interim solution to onItemLoadComplete event being fire before a clip is accesible on stage. This makes use of the
	MovieClipLoader Class. As a result this has only been effective for MovieClip's, and imaged loaded through the loadQueueManager
	class. Ideally this would be extended to make use of the existing events that are dispatched from the MovieClipLoaderClass. 
	Thanks to Dave Myron for pointing out the 'technical/functional' implecations of this event firing before an item was accesible
	on stage.
	


=====================================================
TODO:
=====================================================
	complete accessors for: 
	
	loadDuration
	steps
	loadTime
	
	implement a loadObjectType rather than trying to work out what we are loading autoMagically
	
	seperate object listeners, currently all loading objects listeners all listen
	to all loading objects, there should be a smarter event modle that allows
	individual listeners to just listen to their specific loading objects. Not all loading objects
	Allthough the abillity to listen to all objects does allow for a global loading control to 
	listen to the entire load queue progress.
	
	Implement MovieClipLoader class event ineritance
	
	Implement 'addItems(val:Array)' & 'addItemsAt(arr_val:Array)' methods for managing lists of items to load
	
	compilethe loadQueueManager class into distibutable MXP.
	
=====================================================	
Development Based on: 
=====================================================
LoaderItem Class author Ralf Bokelberg http://www.helpqlodhelp.com/blog/
LoaderQueue Class author Bryan Ledford
LoaderQueue Class author erixtekila copyleft http://www.v-i-a.net 

 *  @class LoaderClass
 *  Implements Colin Moock's Preloading Api as proposed
 *  at http://www.moock.org/blog/archives/000010.html
 * 
 *  This code is supplied as is, use it at your own risk
 *  and please don't remove this header. 
 *
 *  If you plan to use the code on a commercial site, 
 * 	we would happily receive a donation to 
 *  paypal@helpqlodhelp.com. See the docs for the details
 *
 *  Version 1.02
 *	
 *  
 *  Version 1.2
 *  Date 2003/10/27
 *  Author Bryan Ledford
 *  Rewrote for AS 2.0
 *	Added Alex Uhlmann's Priority methods [setPriority, getPriority]
 *
 
 i Hope this information is complete enough not please advise.
=====================================================*/
import mx.events.EventDispatcher;

class com.vpmedia.managers.LoadQueueManager
{
	/*
		Components must declare these to be proper components in the components framework.
	*/
	public static var symbolName:String = "LoadQueueManager";
	public static var className:String = "LoadQueueManager";
	public static var symbolOwner:Object = LoadQueueManager;
	public static var _instance:LoadQueueManager;
	
	private static var __int_defaultTimeoutMS:Number = 50;
	private static var __int_defaultIntervalMS:Number = 5;
	private static var __int_defaultLoadNextMS:Number = 300;
	private static var __int_defaultMinSteps:Number = 5;
	
	private var __arr_defaultExtensions:Array = [".jpg", ".jpeg", ".gif", ".png", ".swf", ".xml", ".txt"];
	private var __arr_curQueue:Array;
	
	private var __bln_autoLoad:Boolean = true;
	private var __bln_isLoading:Boolean = false;
	private var __bln_isPaused:Boolean = false;
	private var __bln_hasTimedOut:Boolean = false;
	
	private var __int_itemID:Number = 0;
	private var __int_loadDurationCurrent:Number = 0;
	private var __int_loadDurationTotal:Number = 0;
	private var __int_loadSpeed:Number = 0;
	private var __int_loadTimeCurrent:Number = 0;
	private var __int_loadTimeTotal:Number = 0;
	private var __int_percentLoadedCurrent:Number = 0;
	private var __int_percentLoadedTotal:Number = 0;
	private var __int_bytesLoaded:Number = 0;
	private var __int_bytesTotal:Number = 0;
	private var __int_timeOutMS:Number = 50;
	private var __int_loadIntervalMS:Number = 5;
	private var __int_loadNextMS:Number = 300;
	private var __int_steps:Number = 1;
	private var __int_loadInterval:Number;
	private var __int_timeInterval:Number;
	private var __int_lastBytesLoaded:Number;
	private var __int_loadNextInterval:Number;
	
	private var __int_timeCurrent:Number = 0;
	
	private var __obj_target:Number;
	private var __obj_targetObject:Number;
	private var __obj_currentLoadTarget:Object;
	private var __obj_currentLoadListener:Object;
	private var __obj_currentLoadObject:Object;
	
	private var __mcl_currentLoadClip:MovieClipLoader;
	private var __obj_mclListnr:Object;
	
	private var __str_currentLoadURL:String = "";
	
	function dispatchEvent(){};
 	function addEventListener(){};
 	function removeEventListener(){};
	
	public function LoadQueueManager(int_timeoutMs:Number, int_intervalMs:Number, int_minSteps:Number)
	{
		EventDispatcher.initialize(this);
		__arr_curQueue = new Array();
	}
	
	/*=====================================================
	LoadQueueManager.addListener();
	used to associate a listener to all displatched events
	
	onLoadStarted
	onLoadProcess
	onLoadItemComplete
	onLoadComplete
	onLoadPause
	onLoadResume
	onLoadInvalidObject
	onTimeOutMSSet
	onIntervalMSSet
	onLoadItemTimedOut
	onLoadStopped
	=====================================================*/
	public function addListener(obj_listner:Object):Void
	{
		addEventListener("onLoadStarted", obj_listner);
		addEventListener("onLoadObserveStarted", obj_listner);
		addEventListener("onLoadProgress", obj_listner);
		addEventListener("onLoadItemComplete", obj_listner);
		addEventListener("onLoadComplete", obj_listner);
		addEventListener("onLoadPause", obj_listner);
		addEventListener("onLoadResume", obj_listner);
		addEventListener("onLoadInvalidObject", obj_listner);
		addEventListener("onTimeOutMSSet", obj_listner);
		addEventListener("onIntervalMSSet", obj_listner);
		addEventListener("onLoadItemTimedOut", obj_listner);
		addEventListener("onLoadStopped", obj_listner);
	}
	
	/*=====================================================
	LoadQueueManager.removeListener();
	used to associate a listener to all displatched events
	
	onLoadStarted
	onLoadProcess
	onLoadItemComplete
	onLoadComplete
	onLoadPause
	onLoadResume
	onLoadInvalidObject
	onTimeOutMSSet
	onIntervalMSSet
	onLoadItemTimedOut
	onLoadStopped
	=====================================================*/
	public function removeListener(obj_listner:Object):Void
	{
		removeEventListener("onLoadStarted", obj_listner);
		removeEventListener("onLoadObserveStarted", obj_listner);
		removeEventListener("onLoadProgress", obj_listner);
		removeEventListener("onLoadItemComplete", obj_listner);
		removeEventListener("onLoadComplete", obj_listner);
		removeEventListener("onLoadPause", obj_listner);
		removeEventListener("onLoadResume", obj_listner);
		removeEventListener("onLoadInvalidObject", obj_listner);
		removeEventListener("onTimeOutMSSet", obj_listner);
		removeEventListener("onIntervalMSSet", obj_listner);
		removeEventListener("onLoadItemTimedOut", obj_listner);
		removeEventListener("onLoadStopped", obj_listner);
	}
	/*=====================================================
	Que Manager Control Methods
	=====================================================*/
	
	/*=====================================================
	LoadQueueManager.load();
	@param obj_target		a reference to the object that will hold the loaded asset
	@param str_URl			the url to the asset that will be loaded
	@param obj_listener		[option] a listener object specifically for this load item
	@return					the index of the item in the load queue array of the loadManager
	=====================================================*/
	public function load(obj_target:Object, str_URl:String, obj_listener:Object):Number
	{
		var int_retVal:Number = -1;
		var bln_validLoadObject:Boolean = (locationToTarget(obj_target) != undefined);
		if(obj_listener != undefined) addListener(obj_listener);
		
		if(!bln_validLoadObject)
		{
			dispatchEvent({type:"onLoadInvalidObject",target:this});
			return int_retVal;
		}
		
		var obj_loadObj:Object = new Object();
		obj_loadObj._target = locationToTarget(obj_target);
		obj_loadObj._url = str_URl;
		obj_loadObj._listener = obj_listener;
		obj_loadObj._priority = ((loadQueue.push(obj_loadObj)) -1);
		obj_loadObj._index = __int_itemID++;
		
		int_retVal = obj_loadObj._index;
		
		if (!isLoading && autoLoad)
		{
			dispatchEvent({type:"onLoadStarted",target:this, loadObject:currentLoadObject});
			loadNext();
		}
		
		return int_retVal;
	}
	
	/*=====================================================
	LoadQueueManager.loadAtPriority();
	pauses the current load operation if the priority is 0, any partially loaded asset will be unloaded and lost.
	adds the target clip at the priority specified by int_priority 
	Then restarts the load queuemanager if it was paused, or resarts the load queue is it is not loading.
	@param obj_target		a reference to the object that will hold the loaded asset
	@param str_URl			the url to the asset that will be loaded
	@param int_priority		an integer that represents the priority the object should be loaded at
	@param obj_listener		[option] a listener object specifically for this load item
	@return					the index of the item in the load queue array of the loadManager
	=====================================================*/
	public function loadAtPriority(obj_target:Object, str_URl:String, int_priority:Number, obj_listener:Object):Number
	{
		if((int_priority === 0) && isLoading) pause();
		
		var int_retVal:Number = -1;
		var int_qLength = loadQueue.length;
		var bln_validLoadObject:Boolean = (locationToTarget(obj_target) != undefined);
		if(obj_listener != undefined) addListener(obj_listener);
		
		if(!bln_validLoadObject)
		{
			dispatchEvent({type:"onLoadInvalidObject",target:this});
			return int_retVal;
		}
		
		var obj_loadObj:Object = new Object();
		obj_loadObj._target = locationToTarget(obj_target);
		obj_loadObj._url = str_URl;
		obj_loadObj._listener = obj_listener;
		obj_loadObj._priority = int_priority;
		obj_loadObj._index = __int_itemID++;
		loadQueue.splice(int_priority, 0, obj_loadObj);
		
		int_retVal = obj_loadObj._index;
		
		if (isPaused)
		{
			dispatchEvent({type:"onLoadStarted",target:this, loadObject:currentLoadObject});
			resume();
		}
		else
		{
			dispatchEvent({type:"onLoadStarted",target:this, loadObject:currentLoadObject});
			loadNext();
		}
		
		return int_retVal;
	}
	
	/*=====================================================
	LoadQueueManager.stop();
	stops the load manager and resets the current load queue
	similar to clear in the old load queu manager
	=====================================================*/
	public function stop():Void
	{
		endInterval();
		__arr_curQueue.length = 0;
		__arr_curQueue = undefined;
		delete __arr_curQueue;
		__arr_curQueue = new Array();
		__bln_isPaused = __bln_isLoading = false;
		__int_itemID = 0;
		
		dispatchEvent({type:"onLoadStopped",target:this});
		
	}
	
	/*=====================================================
	LoadQueueManager.observe();
	pauses the current load operation any partially loaded asset will be unloaded and lost.
	Then and adds the target clip as a priority 0 object to the load queue
	Then restarts the load queuemanager.
	@param obj_target		a reference to the object that will hold the loaded asset
	@param obj_listener		[option] a listener object specifically for this load item
	=====================================================*/
	public function observe(obj_target:Object, obj_listener:Object):Void
	{
		if(isLoading)pause();
		var bln_validLoadObject:Boolean = (locationToTarget(obj_target) != undefined);
		if(obj_listener != undefined) addListener(obj_listener);
		
		if(!bln_validLoadObject)
		{
			dispatchEvent({type:"onLoadInvalidObject",target:this});
			return;
		}
		
		var obj_loadObj:Object = new Object();
		obj_loadObj._target = locationToTarget(obj_target);
		obj_loadObj._url = undefined;
		obj_loadObj._listener = obj_listener;
		obj_loadObj._priority = undefined;
		obj_loadObj._index = __int_itemID++;
		
		loadQueue.splice(0, 0, obj_loadObj);
		
		if(isPaused)
		{
			resume();
		}
		else
		{
			loadNext();
		}
		dispatchEvent({type:"onLoadObserveStarted",target:this, loadObject:currentLoadObject});
	}
	
	/*=====================================================
	LoadQueueManager.pause();
	pauses the current load operation any partially loaded asset will be unloaded and lost.
	=====================================================*/
	public function pause():Boolean
	{
		if(isPaused) return false;
		
		pauseLoading();
		
		dispatchEvent({type:"onLoadPause",target:this, loadObject:currentLoadObject});
		return true;
	}
	
	/*=====================================================
	LoadQueueManager.resume();
	resumes the current load operation from the point at wich it
	was paused. Any parially loaded assets will begin to load from
	scratch
	=====================================================*/
	public function resume():Boolean
	{
		if(!isPaused) return false;
		
		resumeLoading();
		
		dispatchEvent({type:"onLoadResume",target:this, loadObject:currentLoadObject});
		return true;
	}
	
	/*=====================================================
	LoadQueueManager.start();
	starts a paused or non loading load queue
	=====================================================*/
	public function start():Void
	{
		if(isLoading) return;
		if(isPaused) 
		{
			resume();
		}
		else
		{
			loadNext();
		}
	}
	
	/*=====================================================
	LoadQueueManager.addItem();
	@param obj_target		a reference to the object that will hold the loaded asset
	@param str_URl			the url to the asset that will be loaded
	@param obj_listener		[option] a listener object specifically for this load item
	@return					the index of the item in the load queue array of the loadManager
	=====================================================*/
	public function addItem(obj_target:Object, str_URl:String, obj_listener:Object):Number
	{
		var int_retVal:Number = -1;
		var bln_validLoadObject:Boolean = (locationToTarget(obj_target) != undefined);
		if(obj_listener != undefined) addListener(obj_listener);
		
		if(!bln_validLoadObject)
		{
			dispatchEvent({type:"onLoadInvalidObject",target:this});
			return int_retVal;
		}
		
		var obj_loadObj:Object = new Object();
		obj_loadObj._target = locationToTarget(obj_target);
		obj_loadObj._url = str_URl;
		obj_loadObj._listener = obj_listener;
		obj_loadObj._priority = ((loadQueue.push(obj_loadObj)) -1);
		obj_loadObj._index = __int_itemID++;
		int_retVal = obj_loadObj._index;
		
		return int_retVal;
	}
	
	/*=====================================================
	LoadQueueManager.addItem();
	@param obj_target		a reference to the object that will hold the loaded asset
	@param str_URl			the url to the asset that will be loaded
	@param obj_listener		[option] a listener object specifically for this load item
	@return					the index of the item in the load queue array of the loadManager
	=====================================================*/
	public function addItemAtPriority(obj_target:Object, str_URl:String, int_priority:Number, obj_listener:Object):Number
	{
		if((int_priority === 0) && isLoading) pause();
		
		var int_retVal:Number = -1;
		var int_qLength = loadQueue.length;
		var bln_validLoadObject:Boolean = (locationToTarget(obj_target) != undefined);
		if(obj_listener != undefined) addListener(obj_listener);
		
		if(!bln_validLoadObject)
		{
			dispatchEvent({type:"onLoadInvalidObject",target:this});
			return int_retVal;
		}
		
		var obj_loadObj:Object = new Object();
		obj_loadObj._target = locationToTarget(obj_target);
		obj_loadObj._url = str_URl;
		obj_loadObj._listener = obj_listener;
		obj_loadObj._priority = int_priority;
		obj_loadObj._index = __int_itemID++;
		
		loadQueue.splice(int_priority, 0, obj_loadObj);
		
		int_retVal = obj_loadObj._index;
		
		if (isPaused)
		{
			dispatchEvent({type:"onLoadStarted",target:this, loadObject:currentLoadObject});
			resume();
		}
		else
		{
			dispatchEvent({type:"onLoadStarted",target:this, loadObject:currentLoadObject});
			loadNext();
		}
		
		return int_retVal;
	}
	
	/* unused methods for removing items from the queue
	public function removeItem()
	{
	}
	public function removeItemAt(int_i:Number)
	{
	}
	public function removeItems(arr_i:Array)
	{
	}
	*/
	
	
	/*=====================================================
	LoadQueueManager.setPriority();
	pauses the current load operation any partially loaded asset will be unloaded and lost.
	alters the order of the load queue and then resstarts the load manager from priority 0.
	@param int_priority		the desired target priority (0 - loadQueue.length, 0 is highest priority)
	@param obj_targetItem	the target objects current priority, or the URL of the asset that is
							associated with the loadItem
	@return					success or error code as an integer
	=====================================================*/
	public function setPriority(int_priority:Number, obj_targetItem):Number
	{
		var int_retVal:Number = -1;
		var int_qLength = loadQueue.length;
		var obj_tItem:Object;
		// return an eror code as the queue has no items in
		if(!int_qLength) return int_retVal;
		// return an eror code as the target priority is outside the bounds of the current queue
		if(int_priority < 0 || int_priority > __int_itemID || int_priority > int_qLength) return -2;
		
		obj_tItem = getTargetItemObject(obj_targetItem);
		// return an eror code as the target item is not in the queue
		if(obj_tItem == undefined) return -3;
		// return an eror code as the target priority is the current item priority
		if(obj_tItem.target._priority == int_priority) return -4
		
		trace("set Priority  == "+ int_priority + " -- "+ obj_tItem.target._priority);
		
		pause();
		moveQueueItem(obj_tItem.index, int_priority)
		resume();
		
		int_retVal = obj_tItem.index;
		return int_retVal;
	}
	
	/*=====================================================
	LoadQueueManager.getPriority();
	@return					priority (id) of the currently loading item
	=====================================================*/
	public function getPriority():Number
	{
		return currentLoadObject._priority;
	}
	
	public function getTargetItemObject(_val):Object
	{
		var obj_retVal:Object;
		var int_findByPriority:Boolean = (typeof(_val) == "number");
		
		//obj_retVal = int_findByPriority ? findObjectByPriority(_val) : findObjectByURL(_val);
		obj_retVal = int_findByPriority ? findObjectByIndex(_val) : findObjectByURL(_val);
		
		return obj_retVal;
	}
	
	public function setPriorityAt(obj_i, int_i:Number, int_priority:Number)
	{
		var int_qLength = loadQueue.length;
	}
	public function getPriorityAt(obj_i, int_i:Number, int_priority:Number):Number
	{
		return currentLoadObject._priority;
	}
	
	public function getBytesLoaded():Number
	{
		return bytesLoaded;
	}
	public function getBytesTotal():Number
	{
		return bytesTotal;
	}
	
	/*=====================================================
	Read Only Properties
	=====================================================*/
	public function get isLoading():Boolean
	{
		return __bln_isLoading;
	}
	public function get isPaused():Boolean
	{
		return __bln_isPaused;
	}
	public function get loadSpeed():Number
	{
		return __int_loadSpeed;
	}
	public function get loadDurationCurrent():Number
	{
		return __int_loadDurationCurrent;
	}
	
	public function get loadTimeCurrent():Number
	{
		return __int_loadTimeCurrent;
	}
	public function get percentLoaded():Number
	{
		return __int_percentLoadedCurrent;
	}
	
	public function get bytesLoaded():Number
	{
		return __int_bytesLoaded;
	}
	public function get bytesTotal():Number
	{
		return __int_bytesTotal;
	}
	public function get target():Object
	{
		return currentLoadObject._target;
	}
	public function get targetPath():String
	{
		return typeof target == "movieclip" ? targetPath(target) : target;
	}
	public function get targetURL():String
	{
		return currentLoadObject._url;
	}
	public function get currentLoadObject():Object
	{
		return __obj_currentLoadObject;
	}
	public function get loadQueue():Array
	{
		return __arr_curQueue;
	}
	
	/* unused read only properties
	public function get loadDurationTotal():Number
	{
		return __int_loadDurationTotal;
	}
	public function get loadTimeTotal():Number
	{
		return __int_loadTimeTotal;
	}
	*/	
	
	/*=====================================================
	Read and Write Properties
	=====================================================*/
	public function set autoLoad(bln_i:Boolean)
	{
		__bln_autoLoad = bln_i;
	}
	public function get autoLoad():Boolean
	{
		return __bln_autoLoad;
	}
	
	public function set intervalMS(int_i:Number)
	{
		var bln_useDefaultInterval:Boolean = (int_i < 0 || int_i == 0);
		__int_loadIntervalMS = bln_useDefaultInterval ? __int_defaultIntervalMS : int_i;
		dispatchEvent({type:"onIntervalMSSet",target:this, value:bln_useDefaultInterval});
	}
	public function get intervalMS():Number
	{
		return __int_loadIntervalMS;
	}
	
	public function set timeOutMS(int_i:Number)
	{
		var bln_useDefaultTimeout:Boolean = (int_i < 0 || int_i == 0);
		__int_timeOutMS = bln_useDefaultTimeout ? __int_defaultTimeoutMS : int_i;
		dispatchEvent({type:"onTimeOutMSSet",target:this, value:bln_useDefaultTimeout});
	}
	public function get timeOutMS():Number
	{
		return __int_timeOutMS;
	}
	
	/* unused read & write properties
	public function set loadQueue(arr_i:Array)
	{
		__arr_curQueue = arr_i;
	}
	
	public function set steps(int_i:Number)
	{
		__int_steps = int_i;
	}
	public function get steps():Number
	{
		return __int_steps;
	}
	*/
	
	/*=====================================================
	private methods and functions
	=====================================================*/
	private function startLoading():Void
	{
		__bln_isLoading = true;
		__bln_isPaused = false;
		__bln_hasTimedOut = false;
		__obj_mclListnr = __mcl_currentLoadClip = undefined;
		delete __mcl_currentLoadClip, __obj_mclListnr;
		
		var int_targetLoadType:Number;
		var curLoadObject:Object = loadQueue[0];
		__obj_currentLoadObject = curLoadObject;
		__obj_currentLoadTarget = curLoadObject._target;
		__obj_currentLoadListener = curLoadObject._listener;
		__str_currentLoadURL = curLoadObject._url;
		
		int_targetLoadType = targetLoadType(locationToTarget(__obj_currentLoadTarget));
		if(locationIsLevel(__obj_currentLoadTarget)) int_targetLoadType = 4;
		if(__str_currentLoadURL == undefined) int_targetLoadType = -1;
		
		switch(int_targetLoadType)
		{
			case -1:
				// the load object is an observe not a load
				__bln_isLoading = true;
				break;
			case 4:
				// load target in to level
				loadMovie( __str_currentLoadURL, __obj_currentLoadTarget);
				__bln_isLoading = true;
				break;
			case 3:
				// load target into movieclip
				
				//__obj_currentLoadTarget.loadMovie(__str_currentLoadURL);
				
				__obj_mclListnr = new Object();
				__obj_mclListnr._parent = this;
				__obj_mclListnr.onLoadInit = function()
				{
					this._parent.removeMovieClipLoader();
				}
				__mcl_currentLoadClip = new MovieClipLoader();
				__mcl_currentLoadClip.loadClip(__str_currentLoadURL, __obj_currentLoadTarget);
				__mcl_currentLoadClip.addListener(__obj_mclListnr);

				__bln_isLoading = true;
				break;
			case 2:
				// load target into sound
				__obj_currentLoadTarget.loadSound(__str_currentLoadURL);
				__bln_isLoading = true;
				break;
			case 1:
				// load target into xml, or load vars object
				__obj_currentLoadTarget.load(__str_currentLoadURL);
				__bln_isLoading = true;
				break;
			default:
				// load target is not a valid location
				__bln_isLoading = false;
				break;
		}
		
		if(isLoading)
		{
			startInterval();
		}
		else
		{
			dispatchEvent({type:"onLoadInvalidObject",target:this});
		}
	}
	
	private function pauseLoading()
	{
		var int_targetLoadType:Number = targetLoadType(locationToTarget(__obj_currentLoadTarget));
		if(locationIsLevel(__obj_currentLoadTarget)) int_targetLoadType = 4;
		
		switch(int_targetLoadType)
		{
			case 4:
				// load target in to level
				loadMovie(undefined, __obj_currentLoadTarget);
				unloadMovie(__obj_currentLoadTarget);
				break;
			case 3:
				// load target into movieclip
				__mcl_currentLoadClip.unloadClip(__obj_currentLoadTarget);
				__obj_currentLoadTarget.loadMovie(undefined);
				__obj_currentLoadTarget.unloadMovie();
				break;
			case 2:
				// load target into sound
				__obj_currentLoadTarget.loadSound(undefined);
				__obj_currentLoadTarget.unloadMovie();
				break;
			case 1:
				// load target into mxl, or load vars object
				__obj_currentLoadTarget.load(undefined);
				break;
		}
		
		__bln_isPaused = true;
		__bln_isLoading = false;
		endInterval();
	}
	
	private function resumeLoading()
	{
		__bln_isPaused = false;
		loadNext();
	}
	/*
	set the loading interval
	*/
	private function startInterval():Void
	{
		if (__int_loadInterval != undefined)
		{
			endInterval();
		}
		
		__int_loadInterval = setInterval(this, "onInterval", intervalMS);
		__int_timeInterval = setInterval(this, "startTimeOut", intervalMS);
	}
	/*
	set the timeout interval
	*/
	private function startTimeOut():Void
	{
		var currentLoc = targetToLoc(target);
		var bln_hasBytesTorL:Boolean = (checkBytesTotal(currentLoc) && checkBytesLoaded(currentLoc));
		if(bln_hasBytesTorL)endTimeOut();
		if(__int_timeCurrent >= timeOutMS && !bln_hasBytesTorL)
		{
			endTimeOut();
			__bln_hasTimedOut = true;
		}
		++__int_timeCurrent;
	}
	/*
	remove the timeout interval
	*/
	private function endTimeOut():Void
	{
		clearInterval(__int_timeInterval);
		__int_timeInterval = undefined;
		__int_timeCurrent = 0;
	}
	/*
	remove loading interval
	*/
	private function endInterval():Void
	{
		if (__int_loadInterval != undefined)
		{
			endTimeOut();
			clearInterval(__int_loadInterval);
			__obj_mclListnr = undefined;
			__mcl_currentLoadClip = undefined;
			__int_loadInterval = undefined;
			delete __mcl_currentLoadClip, __obj_mclListnr;
			__bln_isLoading = false;
		}
	}
	
	public function removeMovieClipLoader():Void
	{
		__obj_mclListnr = __mcl_currentLoadClip = undefined;
		delete __mcl_currentLoadClip, __obj_mclListnr;
	}
	
	/*
	the loading progress interval function
	*/
	private function onInterval():Void
	{
		var currentLoc = targetToLoc(target);
		
		if (! checkBytesTotal(currentLoc)) return;
		if (! checkBytesLoaded(currentLoc)) return;
		
		// check to see if the item has loaded
		if(checkBytesTotal(currentLoc) && checkBytesLoaded(currentLoc))
		{
			if(checkComplete(currentLoc) && __mcl_currentLoadClip == undefined)
			{
				endInterval();
				loadQueue.splice(0,1);
				__int_loadNextInterval = setInterval(this, "loadNext", __int_defaultLoadNextMS);
				dispatchEvent({type:"onLoadItemComplete",target:this, loadObject:currentLoadObject});
				return;
			}
		}
		// check to see if the item has timed out
		else if(__bln_hasTimedOut)
		{
			endInterval();
			loadQueue.splice(0,1);
			__int_loadNextInterval = setInterval(this, "loadNext", __int_defaultLoadNextMS);
			dispatchEvent({type:"onLoadItemTimedOut",target:this, loadObject:currentLoadObject});
			return;
		}
		dispatchEvent({type:"onLoadProgress",target:this, loadObject:currentLoadObject});
	}
	
	/*
	checks to see if there are any other items to load in the load queue
	if there are not then the queue is loaded, other wise load the next
	item in the queue
	*/
	private function loadNext():Void
	{
		clearInterval(__int_loadNextInterval);
		if(checkLoadQueue())
		{
			startLoading();
		}
		else
		{
			__bln_isLoading = false;
			__bln_isPaused = false;
			
			dispatchEvent({type:"onLoadComplete",target:this, loadObject:currentLoadObject});
		}
	}
	
	private function targetLoadType(_val):Number
	{
		var int_retVal:Number = 0;
		
		if(typeof(_val.load) == "function")
		{
			int_retVal = 1;
		}
		else if(typeof(_val.loadSound) == "function") 
		{
			int_retVal = 2;
		}
		else if(typeof(_val.loadMovie) == "function") 
		{
			int_retVal = 3;
		}
		if(typeof(_val) == "string" || locationIsLevel(_val)) 
		{
			int_retVal = 4;
		}
		return int_retVal;
	}
	
	private function targetToLoc(_val)
	{
		return (typeof(_val) == 'string') ? eval(String(_val)) : _val;	
	}
	
	private function targetToString(_val):String
	{
		return String(_val);	
	}
	
	private function locationToTarget(_val):Object
	{
		var int_loactionType:Number = getLocationType(_val);
		var obj_retval:Object;
		
		switch(int_loactionType)
		{
			case 1:
				obj_retval = "_level" + _val;
				break;
			case 0:
			case 2:
			case 3:
			case 4:
				obj_retval = _val;
				break;
			case 5:
				if(locationIsLevelPath(_val))
				{
					obj_retval = eval(String(_val));
					break;
				}
				else if(typeof(_val) == "string" && _val.length > 0)
				{
					obj_retval = _val;
				}
				break;
			default:
				obj_retval = undefined;
		}
		
		return obj_retval;
	}
	
	private function getLocationType(_val):Number
	{
		var int_retVal:Number = -1;
		if(!locationIsLoadable(_val))
		
		var str_valType:String = typeof(_val);
		switch(str_valType)
		{
			case "number":
				int_retVal = 1;
				break;
			case "movieclip":
				int_retVal = 2;
				break;
			case "xml":
				int_retVal = 3;
				break;
			case "sound":
				int_retVal = 4;
				break;
			case "string":
				int_retVal = 5;
				break;
			default:
				int_retVal = 0;
				break;
		}
		
		return int_retVal;
	}
	
	private function locationIsLoadable(_val):Boolean
	{
		var bln_retVal:Boolean = typeof(_val.getBytesTotal) == "function" && typeof(_val.getBytesLoaded) == "function";
		
		return bln_retVal;
	}
	
	private function locationIsLevelPath(_val):Boolean
	{
		var bln_retVal:Boolean = false;
		
		bln_retVal = (locationIsLevel (_val) && locationIsPath (_val));
		
		return bln_retVal;
	}
	
	private function locationIsLevel(_val):Boolean
	{
		var bln_retVal:Boolean = _val.indexOf("_level") == 0 && ! isNaN(_val.substring(6));
		
		return bln_retVal;
	}
	
	private function locationIsPath(_val):Boolean
	{
		var bln_retVal:Boolean = (typeof(_val) == "string") && (typeof(eval(String(_val))) == "movieclip") && (eval(String(_val)) != _level0 || _val == "_level0");
		
		return bln_retVal
	}
	
	private function checkBytesTotal (_val):Boolean
	{
		var int_BytesTotal:Number = _val.getBytesTotal();
		
		if (isNaN(int_BytesTotal) || int_BytesTotal == undefined || int_BytesTotal <= 0)
		{
			__int_bytesTotal = null;
			return false;
		}
		__int_bytesTotal = int_BytesTotal;
		return true;
	}
	
	private function checkBytesLoaded (_val):Boolean
	{
		var int_BytesLoaded:Number = _val.getBytesLoaded();
		
		if (isNaN(int_BytesLoaded) || int_BytesLoaded == undefined || int_BytesLoaded <= 0)
		{
			__int_bytesLoaded = null;
			return false;
		}
		__int_bytesLoaded = int_BytesLoaded;
		return true;
	}
	
	private function checkComplete (_val):Boolean
	{
		var bln_retVal:Boolean = false;
		var int_bTotal = _val.getBytesTotal();
		var int_bLoaded = _val.getBytesLoaded();
		var int_bPercentLoaded = Math.ceil((int_bLoaded / int_bTotal)*100);
		__int_percentLoadedCurrent = int_bPercentLoaded;
		
		if(int_bLoaded == null || int_bTotal == undefined || isNaN(int_bTotal)) return bln_retVal;
		if(int_bLoaded == null || int_bLoaded == undefined || isNaN(int_bLoaded)) return bln_retVal;
		
		if(int_bTotal === int_bLoaded)
		{
			bln_retVal = true;
		}
		else if(isNaN(int_bPercentLoaded))
		{
			bln_retVal = false;
		}
		
		return bln_retVal;
	}
	
	private function checkLoadQueue():Boolean
	{
		var bln_qLength:Boolean = (loadQueue.length > 0);
		return bln_qLength;
	}
	
	private function findObjectByPriority(int_i:Number):Object
	{
		var int_qLength = loadQueue.length;
		var obj_curLoadObject:Object;
		var obj_retVal:Object;
		var i:Number = 0;
		
		while(i < int_qLength)
		{
			obj_curLoadObject = loadQueue[i];
			if(obj_curLoadObject._priority === int_i)
			{
				obj_retVal = {target:loadQueue[i], index:i};
				i = int_qLength;
			}
			++i;
		}
		
		return obj_retVal;
	}
	
	private function findObjectByIndex(int_i:Number):Object
	{
		var int_qLength = loadQueue.length;
		var obj_curLoadObject:Object;
		var obj_retVal:Object;
		var i:Number = 0;
		
		while(i < int_qLength)
		{
			obj_curLoadObject = loadQueue[i];
			if(obj_curLoadObject._index === int_i)
			{
				obj_retVal = {target:loadQueue[i], index:i};
				i = int_qLength;
			}
			++i;
		}
		
		return obj_retVal;
	}
	
	private function findObjectByURL(str_i:String):Object
	{
		var int_qLength = loadQueue.length;
		var obj_curLoadObject:Object;
		var obj_retVal:Object;
		var i:Number = 0;
		
		while(i < int_qLength)
		{
			obj_curLoadObject = loadQueue[i];
			if(obj_curLoadObject._url.toLowerCase() === str_i.toLowerCase() )
			{
				obj_retVal = {target:loadQueue[i], index:i};
				i = int_qLength;
			}
			++i;
		}
		
		return obj_retVal;
	}

	private function moveQueueItem(int_curIndex:Number, int_newIndex:Number):Boolean
	{
		var bln_retVal:Boolean = true;
		loadQueue.splice(int_newIndex, 0, loadQueue.splice(int_curIndex, 1)[0]);
		return bln_retVal;
	}
}