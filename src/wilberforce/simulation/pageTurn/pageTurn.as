
/**
* 
* PageFlip code converted by Simon Oliver into encapsulated class.
* 
* TODO - Still heavy dependancy on stage assets. remove
* TODO - Tidy up the AS1-ish code
* 
* Integrated into Wilberforce flash library. Now dependant on pixlib
* 
* Most of the work has been done by Macc - abel@iparigrafika.hu
* The original version was at - http://www.iparigrafika.hu/pageflip
* 
* Original AS2 syntax conversion bt MindGraphix - http://www.mindgraphix.com/
* 
*/

import com.bourre.commands.Delegate;
import com.bourre.transitions.FPSBeacon;
import com.bourre.transitions.IFrameListener;
import wilberforce.events.simpleEventHelper;

import com.bourre.events.BasicEvent;
import com.bourre.events.EventType

class wilberforce.simulation.pageTurn.pageTurn extends simpleEventHelper implements IFrameListener
{

	var pw:Number = 300;//page width in pixel
	var ph:Number = 400;//page height in pixel
	var pageOrder:Array = new Array();// this no changed!
	var pageCanTear:Array = new Array();// this no changed!
	var pageCantTurn:Array = new Array();
	var maxpage:Number = 0;
	var intervalID:Number = 0;
	
	var _container:MovieClip;
	// Not sure what this is used for right now
	var anim:MovieClip;
	
	//_container in the library must have the same size, the script will not resize them!
	//page data... (export names/tearing flag)

	var snd0:Sound;
	var snd1:Sound;
	var snd2:Sound;
	 
	/**
	* Configurable elements
	*/
	var page:Number = 0;//first page (normally it is 0 = the page before the cover = blank page)
	var hcover:Boolean = true;//hard cover on/off
	var clickarea:Number = 64;//pixel width of the click sensitive area at the edges..
	var afa:Number = 56;//width of the autoflip starter square.
	var gs:Number = 2;//goto page flip speed
	var ps:Number = 5;//mouse pursuit speed
	var es:Number = 3;//flip speed after mouse btn release
	var canflip:Boolean = true;//page flipping enabled
	//var transparency:Boolean = true;//use transparent _container or not (1 level transparency)
	var transparency:Boolean = false;//use transparent _container or not (1 level transparency)
	var lcover:Boolean = true;//large cover on/off
	var lcaddx:Number = 40;//width difference
	var lcaddy:Number = 20;//height difference on top/bottom
	var SoundOn:Boolean = true;//use page sounds
	
	
	public static var PAGE_PREFLIP_START_EVENT:EventType=new EventType("onPagePreFlipStart");
	public static var PAGE_PREFLIP_STOP_EVENT:EventType=new EventType("onPagePreFlipStop");
	public static var PAGE_TURN_START_EVENT:EventType=new EventType("onPageTurnStart");
	public static var PAGE_TURN_STOP_EVENT:EventType=new EventType("onPageTurnStop");
	
	private var _doingPreflip:Boolean;

	private var gpage:Number = 0;//gotoPage No
	private var gflip:Boolean = false;//gotoPage flip
	private var gdir:Number = 0;//goto direction...
	private var gskip:Boolean = false;//skip _container	***
	private var gtarget:Number = 0;//target when skipping
	private var aflip:Boolean = false;//auto flip
	private var flip:Boolean = false;//pageflip
	private var flipOff:Boolean = false;//terminateflip
	private var flipOK:Boolean = false;//good flip
	private var hflip:Boolean = false;//hardflip (the cover of the book)
	private var rotz:Number = -30;//hardflip max y difference
	private var preflip:Boolean = false;//corner flip status
	private var ctear:Boolean = false;//actual page status
	private var tear:Boolean = false;
	private var teard:Number = 0;
	private var tlimit:Number = 80;
	private var removedPages:Array = new Array();//list of removed _container!
	private var m_x:Number = 0;//mouse x
	private var m_y:Number = 0;//mouse y
	private var mpx:Number = 0;//mousepos at click
	private var mpy:Number = 0;//mousepos at click
	private var sx:Number = 0;//startpoint when flipping
	private var sy:Number = 0;//startpoint when flipping
	private var ax:Number = 0;//auto x,y
	private var ay:Number = 0;
	private var acnt:Number = 0;
	private var aadd:Number = 0;
	private var aamp:Number = 0;
	private var AM:Number = Math.PI / 180;
	//________________________//
	private var ox:Number = 0;
	private var oy:Number = 0;
	private var offs:Number = 0;
	var pageNumber:Array = new Array();
	var propertyListArray=new Array();
	private var pageN:Array = new Array();
	private var pageO:Array = new Array();
	private var r0:Number = 0;
	private var r1:Number = 0;
	private var rr0:Number = 0;
	private var rr1:Number = 0;
	private var oox:Number = 0;
	private var ooy:Number = 0;
	private var osx:Number = 0;
	private var osy:Number = 0;
	private var hit:Number = 0;
	private var d_x1:Number = 0;
	private var d_x2:Number = 0;
	private var d_y:Number = 0;
	private var pmh:Number = 0;
	private var r:Number = 0;
	private var a:Number = 0;
	private var dummy:Number = 0;
	private var tox:Number = 0;
	private var toy:Number = 0;
	private var vx:Number = 0;
	private var vy:Number = 0;
	private var a1:Number = 0;
	private var a2:Number = 0;
	private var cx:Number = 0;
	private var cy:Number = 0;
	private var pleft:Object = new Object();
	private var pleftb:Object = new Object();
	private var tm:Object = new Object();
	private var sp2:Object = new Object();
	private var sp3:Object = new Object();
	private var pright:Object = new Object();
	private var prightb:Object = new Object();
	private var p:Number = 0;
	private var d:Number = 0;
	
	
	private var _interactionEnabled:Boolean;
	private var randomId=random(1000);
	function pageTurn(container:MovieClip,width:Number,height:Number)
	{
		super();
		if (width) pw=width;
		if (height) ph=height;
		trace("Created "+container);
		_container=container;
		
		//initializing mouse click handler ---------------------------------------------------------------------------
		Mouse.addListener(this);
		_global.mcnt = 0;//counter (used on a page where is an animation)
	
		
		trace("pageOrder is "+pageOrder+" page is "+page);
		
		snd0 = new Sound();//adding sound objects
		snd1 = new Sound();
		snd2 = new Sound();
		
		snd0.attachSound("pf1");
		snd1.attachSound("pf2");
		snd2.attachSound("pf3");
		
		addPage("start");
		_doingPreflip=false;
		_interactionEnabled=true;
	}
	
	public function destroy()
	{
		Mouse.removeListener(this);
		FPSBeacon.getInstance().removeFrameListener(this);
	}
	
	public function setInteractionEnabled(value:Boolean)
	{
		
		_interactionEnabled=value;
		trace("SETTING INTERACTIONENABLED TO "+_interactionEnabled+" - "+randomId);
	}
	
	
	
	
	public function initialise():Void
	{
		addPage("end");
		page=0;
		FPSBeacon.getInstance().addFrameListener(this);
		resetPages();
		reset();
	}
	
	//
	//pageflip code by Macc ---------------------------------------------------------------------------------------------------------------------------
	
	public function addPage(ename:String, propertyList:Object,cantTurn:Boolean,tear:Boolean):Void {
		//defining _container... -------------------------------------------------------------------------------------------
		if (ename == "start") {
			pageOrder = new Array();
			pageCanTear = new Array();
			pageCantTurn=new Array();
			page = 0;
			ename = "blankpage";
		}
		if (ename == "end") {
			maxpage = page - 1;
			ename = "blankpage";
		}
		tear = tear == undefined ? false : tear;
		pageOrder[page] = ename;
		pageCantTurn[page]=cantTurn;
		propertyListArray[page]=propertyList;
		pageCanTear[page] = tear;
		
		page++;
	}
	
	public function deletePage(pageIndex:Number):Void
	{
		pageOrder.splice(pageIndex,1);
		pageCantTurn.splice(pageIndex,1);
		propertyListArray.splice(pageIndex,1);
		pageCanTear.splice(pageIndex,1);
		
		// Change the current page index
		if (page>pageIndex) page--;
		maxpage--;
	}
	
	public function overwritePageData(index:Number,ename:String, propertyList:Object,cantTurn:Boolean,tear:Boolean)
	{
		pageOrder[index] = ename;
		pageCantTurn[index]=cantTurn;
		propertyListArray[index]=propertyList;
		pageCanTear[index] = tear;
	}
	
	private function reset():Void {
		//initializing _container... ---------------------------------------------------------------------------------------
		dummy = 2 * Math.sqrt(ph * ph + pw * pw);
		_container.p4.page._x = -pw;
		_container.p4._x = pw;
		_container.p1.page._x = -pw;
		_container.p1._x = 0;
		_container.flip.p2.page._x = -pw;
		_container.flip.p2._x = pw;
		_container.flip.p3.page._x = -pw;
		_container.flip.p3._x = 0;
		_container.p0.page._x = -pw;
		_container.p0._x = 0;
		_container.p5.page._x = -pw;
		_container.p5._x = pw;
		_container.pLL.page._x = -pw;
		_container.pLL._x = 0;
		_container.pLR.page._x = -pw;
		_container.pLR._x = pw;
		_container.pgrad._visible = false;
		_container.mask._visible = false;
		_container.flip._visible = false;
		_container.flip.p3mask._width = pw * 2;
		_container.pgmask._width = pw * 2;
		_container.flip.p3mask._height = ph;
		_container.pgmask._height = ph;
		_container.center._height = ph + 2 * lcaddy;
		_container.flip.fmask.page.pf._width = pw;
		_container.center._width = 6;
		_container.flip.fmask.page.pf._height = ph;
		_container.mask._height = dummy;
		_container.pgrad._height = dummy;
		_container.flip.p3shadow._height = dummy;
		_container.flip.flipgrad._height = dummy;
		var pageNumber = new Array();
		for (var i = 0; i <= (maxpage + 1); i++) {
			pageNumber[i] = i;
		}
	}
	
	private function onMouseDown():Void
	{
		var tXmouse = _container._xmouse;
		
		if (tXmouse<0 && pageCantTurn[page]) return;
		if (tXmouse>0 && pageCantTurn[page+1]) return;
		
		if (!_interactionEnabled) return;
		
		if (flip && !aflip) { //  && !preflip) {
			flipOK = false;
			if (sx < 0 && _container._xmouse > 0) {
				flipOK = true;
			}
			if (sx > 0 && _container._xmouse < 0) {
				flipOK = true;
			}
			flipOff = true;
			flip = false;
		} else if ((flipOff || aflip || !canflip) && !preflip) {
			trace("donothing");
		} else {
			oox = ox;
			ooy = oy;
			osx = sx;
			osy = sy;
			hit = hittest();
			//hittest
			if (hit) {
				//if (!pageCantTurn[page])
				//{
					startsnd(1);//Sound
					anim._visible = false;
					flip = true;
					flipOff = false;
					tear = false; //not tearing yet...
					ox = hit * pw;
					sx = hit * pw;
					if (preflip) {
						aflip = false;
						preflip = false;
						ox = oox;
						oy = ooy;
						sx = osx;
						sy = osy;
					}
					_container.flip.setMask(_container.mask);
					mpx = _container._xmouse;
					mpy = _container._ymouse;
					//oef();
					_oEB.broadcastEvent(new BasicEvent(PAGE_TURN_START_EVENT,this));
					onEnterFrame();
					//_quality = "MEDIUM";	//it is the place to degrade image quality while turning _container if the performance is too low.
				//}
			}
		}
	};
	
	private function onMouseUp():Void {
		if (!_interactionEnabled) return;
		trace("MOUSEUP _interactionEnabled:"+_interactionEnabled+" - "+randomId);
		if (flip && !tear) {
			d_x1 = Math.abs(_container._xmouse);
			d_x2 = Math.abs(_container._xmouse - mpx);
			d_y = Math.abs(_container._xmouse);
			if ((d_x1 > (pw - afa) && d_y > (ph / 2 - afa) && d_x2 < afa) || preflip) {
				flip = false;
				preflip = false;
				autoflip();
				startsnd(2);//sound
			} else if (!preflip) {
				preflip = false;
				flipOK = false;
				if (sx < 0 && _container._xmouse > 0) {
					flipOK = true;
				}
				if (sx > 0 && _container._xmouse < 0) {
					flipOK = true;
				}
				flipOff = true;
				flip = false;
				if (flipOK) {
					startsnd(2);
				}
				//sound
			}
		}
	};
	
	private function hittest() {
		//hittest at mouse clicks, if click is over the book -> determining turning direction ------------------------------------
		m_x = _container._xmouse;
		m_y = _container._ymouse;
		pmh = ph / 2;
		//
		/*
		trace("-----------");
		trace("X:"+m_x);
		trace("Y:"+m_y);
		trace("(pw - afa):"+(pw - afa));
		
		trace("pw:"+pw);
		trace("ph:"+ph);
		trace("ph:"+ph);
		trace("afa:"+pw);
		
		trace("MINY "+(ph-clickarea)+" MAX "+ph);
		*/
		trace("(ph / 2 - afa):"+(ph / 2 - afa));
		trace("ph/2:"+ph/2);
		//if (m_x > (pw - afa) && m_x < pw && m_y > (ph / 2 - afa) && m_y < (ph / 2)) {
			
		if (m_y <= pmh && m_y >= -pmh && m_x <= pw && m_x >= -pw) { //ha a megadott intervallumban klikkelunk, akkor lapozhatunk
			
			
			if (m_y>(ph/2) || m_y<((ph/2)-clickarea)) return 0;
			trace("OVER!");
			r = Math.sqrt(m_x * m_x + m_y * m_y);
			a = Math.asin(m_y / r);
			m_y = Math.tan(a) * pw;
			if (m_y > 0 && m_y > ph / 2) {
				m_y = ph / 2;
			}
			if (m_y < 0 && m_y < -ph / 2) {
				m_y = -ph / 2;
			}
			oy = m_y;
			sy = m_y;
			r0 = Math.sqrt((sy + ph / 2) * (sy + ph / 2) + pw * pw);
			r1 = Math.sqrt((ph / 2 - sy) * (ph / 2 - sy) + pw * pw);
			pageN = eval("_container.flip.p2.page");
			pageO = eval("_container.flip.p3");
			offs = -pw;
			_container.flip.fmask._x = pw;
			if (m_x < -(pw - clickarea) && page > 0) {
				//>-----> flip backward
				_container.flip.p3._x = 0;
				hflip = checkCover(page, -1);
				setPages(page - 2, page - 1, page, page + 1);
				ctear = pageCanTear[page - 1];
				return -1;
			}
			if (m_x > (pw - clickarea) && page < maxpage) {
				//<-----< flip forward
				_container.flip.p3._x = pw;
				hflip = checkCover(page, 1);
				setPages(page, page + 2, page + 1, page + 3);
				ctear = pageCanTear[page + 2];
				return 1;
			}
		} else {
			trace("OUT");
			return 0;
		}//wrong click
	}
	
	private function checkCover(p, dir):Boolean {
		if (hcover) {
			if (dir > 0) {
				if (p == (maxpage - 2) || p == 0) {
					return true;
				}
			} else {
				if (p == maxpage || p == 2) {
					return true;
				}
			}
		}
		return false;
	}
	
	private function corner():Boolean {
		var m_x = Math.abs(_container._xmouse);
		// temporary to only allow bottom right
		var m_y = _container._ymouse;
		//var m_y = Math.abs(_container._ymouse);
		if (m_x > (pw - afa) && m_x < pw && m_y > (ph / 2 - afa) && m_y < (ph / 2)) {
			return true;
		}
		return false;
	}
	
	function onEnterFrame():Void {
		_global.mcnt++;
		//main counter incrase (need for some page effect);
		if (!flip && corner()) {//corner mouseover
		
			var tTurnOk:Boolean=true;
			var tXmouse:Number=_container._xmouse;
			if (tXmouse<0 && pageCantTurn[page]) tTurnOk=false;
			if (tXmouse>0 && pageCantTurn[page+1]) tTurnOk=false;
			if (!_interactionEnabled) tTurnOk=false;;
			if (tTurnOk)
			{
				if (!_doingPreflip)
				{
					trace("HEREA "+preflip);
					_doingPreflip=true;
					_oEB.broadcastEvent(new BasicEvent(PAGE_PREFLIP_START_EVENT,this));
				}
				preflip = true;
				if (!autoflip()) {
					preflip = false;
				}
			}
		}
		if (preflip && !corner()) {
			trace("HEREB");
			_doingPreflip=false;
			_oEB.broadcastEvent(new BasicEvent(PAGE_PREFLIP_STOP_EVENT,this));
			preflip = false;
			flip = false;
			flipOK = false;
			flipOff = true;
		}
		getm();
		if (aflip && !preflip) {
			m_y = (ay += (sy - ay) / (gflip ? gs : ps));
			acnt += aadd;
			ax -= aadd;
			if (Math.abs(acnt) > pw) {
				trace("HERE1");
				flipOK = true;
				flipOff = true;
				flip = false;
				aflip = false;
			}
		}
		if (flip) { //page turning is in progress...
			if (tear) {
				m_x = tox;
				m_y = (toy += teard);
				teard *= 1.2;
				if (Math.abs(teard) > 1200) {
					flipOff = true;
					flip = false;
				}
			} else {
				m_x = (ox += (m_x - ox) / (gflip ? gs : ps));
				m_y = (oy += (m_y - oy) / (gflip ? gs : ps));
			}
			calc(m_x, m_y); //positioning _container and shadows
		}
		if (flipOff) {
			//terminating page turning effect... (comlplete turning... dropped on the other side)
			if (flipOK || tear) {
				m_x = (ox += (-sx - ox) / (gflip ? gs : es));
				m_y = (oy += (sy - oy) / (gflip ? gs : es));
				calc(m_x, m_y);
				if (m_x / -sx > 0.99 || tear) {
					//we are done with turning, so stop all turning issue...
					flip = false;
					flipOK = false;
					flipOff = false;
					_container.pgrad._visible = false;
					_container.flip._visible = false;
					//_quality = "BEST";	//if quality is decrased during turning effect, you must reset its default value!
					if (tear) {
						//if tear: remove page!!!
						removePage((sx < 0) ? page : page + 1);
						page += (sx < 0) ? -2 : 0;
					} else {
						page += (sx < 0) ? -2 : 2; //and tourning _container at pagenumber level...
					}
					if (gskip) {
						page = gtarget;
					}
					setPages(page, 0, 0, page + 1);
					tear = false;
					if (gpage > 0 && !gskip) { //gotoflip active -> is there another flipping left?
						gpage--;
						autoflip();
						startsnd(0);//sound
					} else {
						gflip = false;
						gskip = false;
					}
					_oEB.broadcastEvent(new BasicEvent(PAGE_TURN_STOP_EVENT,this));
				}
			} else {
				//terminating page turning effect... (incomlplete turning... dropped on the dragged side)
				m_x = (ox += (sx - ox) / 3);
				m_y = (oy += (sy - oy) / 3);
				calc(m_x, m_y);
				if (m_x / sx > 0.99) {
					//we are done with turning, so stop all turning issue...
					flip = false;
					flipOff = false;
					aflip = false;
					_container.pgrad._visible = false;
					_container.flip._visible = false;
					//_quality = "HIGH"; 	//if quality is decrased during turning effect, you must reset its default value!
					setPages(page, 0, 0, page + 1); //no change at pagenumbers..
					
					_oEB.broadcastEvent(new BasicEvent(PAGE_TURN_STOP_EVENT,this));
				}
			}
		}
	}
	
	private function calc(m_x, m_y):Void {
		//positioning _container and shadows by x,y reference points --------------------------------------------------
		if (hflip) {//hardflip...
			var xp:Number = (sx < 0) ? -m_x : m_x;
			if (xp > 0) {
				sp2._visible = false;
				sp3._visible = true;
				scalc(sp3, m_x);
			} else {
				sp3._visible = false;
				sp2._visible = true;
				scalc(sp2, m_x);
			}
			_container.flip.setMask(null);
			_container.flip._visible = true;
			_container.flip.fgrad._visible = false;
			_container.flip.p2._visible = false;
			_container.flip.p3._visible = false;
			return;
		} else {
			_container.flip.fgrad._visible = true;
		}
		//normal flipping process---------------------------------------------------------------------
		rr0 = Math.sqrt((m_y + ph / 2) * (m_y + ph / 2) + m_x * m_x);
		rr1 = Math.sqrt((ph / 2 - m_y) * (ph / 2 - m_y) + m_x * m_x);
		if ((rr0 > r0 || rr1 > r1) && !tear) {
			// we can tear off _container now:) - // so reference points must be recalculated!
			if (m_y < sy) { // k1-gyel kell osszehasonlitani!
				a = Math.asin((ph / 2 - m_y) / rr1);
				m_y = (ph / 2 - Math.sin(a) * r1);
				m_x = (m_x < 0) ? -Math.cos(a) * r1 : Math.cos(a) * r1;
				if (m_y > sy) {
					if ((sx * m_x) > 0) {
						m_y = sy;
						m_x = sx;
					} else {
						m_y = sy;
						m_x = -sx;
					}
				}
				if ((rr1 - r1) > tlimit && ctear) {
					teard = -5;
					tear = true;
					tox = m_x;
					ox = m_x;
					toy = m_y;
					oy = m_y;
				}
			} else { // k0-val kell osszehasonlitani!
				a = Math.asin((m_y + ph / 2) / rr0);
				m_y = Math.sin(a) * r0 - ph / 2;
				m_x = (m_x < 0) ? -Math.cos(a) * r0 : Math.cos(a) * r0;
				if (m_y < sy) {
					if ((sx * m_x) > 0) {
						m_y = sy;
						m_x = sx;
					} else {
						m_y = sy;
						m_x = -sx;
					}
				}
				if ((rr0 - r0) > tlimit && ctear) {
					teard = 5;
					tear = true;
					tox = m_x;
					ox = m_x;
					toy = m_y;
					oy = m_y;
				}
			}
		}
		if ((sx < 0 && (m_x - sx) < 10) || (sx > 0 && (sx - m_x) < 10)) {
			if (sx < 0) {
				m_x = -pw + 10;
			}
			if (sx > 0) {
				m_x = pw - 10;
			}
		}
		//calculating flipping process 
		_container.flip._visible = true;
		_container.flip.p3shadow._visible = !tear;
		_container.pgrad._visible = !tear;
		_container.flip.p2._visible = true;
		_container.flip.p3._visible = true;
		//equation of the line
		vx = m_x - sx;
		vy = m_y - sy;
		a1 = vy / vx;
		a2 = -vy / vx;
		cx = sx + (vx / 2);
		cy = sy + (vy / 2);
		//trigonometriai szamitasok
		//calculating rotation of the page, and the masks
		r = Math.sqrt((sx - m_x) * (sx - m_x) + (sy - m_y) * (sy - m_y));
		a = Math.asin((sy - m_y) / r);
		if (sx < 0) {
			a = -a;
		}
		var ad:Number = a / AM;
		//in degree
		pageN._rotation = ad * 2;
		r = Math.sqrt((sx - m_x) * (sx - m_x) + (sy - m_y) * (sy - m_y));
		
		var rl:Number = (pw * 2);
		
		var nx:Number=0;
		var ny:Number=0;
		if (sx > 0) {
			//flip forward
			_container.mask._xscale = 100;
			nx = cx - Math.tan(a) * (ph / 2 - cy);
			ny = ph / 2;
			if (nx > pw) {
				nx = pw;
				ny = cy + Math.tan(Math.PI / 2 + a) * (pw - cx);
			}
			pageN.pf._x = -(pw - nx);
			_container.flip.fgrad._xscale = (r / rl / 2) * pw;
			_container.pgrad._xscale = -(r / rl / 2) * pw;
			_container.flip.p3shadow._xscale = (r / rl / 2) * pw;
		} else {
			//flip backward
			_container.mask._xscale = -100;
			nx = cx - Math.tan(a) * (ph / 2 - cy);
			ny = ph / 2;
			if (nx < -pw) {
				nx = -pw;
				ny = cy + Math.tan(Math.PI / 2 + a) * (-pw - cx);
			}
			pageN.pf._x = -(pw - (pw + nx));
			_container.flip.fgrad._xscale = -(r / rl / 2) * pw;
			_container.pgrad._xscale = (r / rl / 2) * pw;
			_container.flip.p3shadow._xscale = -(r / rl / 2) * pw;
		}
		_container.mask._x = cx;
		_container.mask._y = cy;
		_container.mask._rotation = ad;
		pageN.pf._y = -ny;
		pageN._x = nx + offs;
		pageN._y = ny;
		_container.flip.fgrad._x = cx;
		_container.flip.fgrad._y = cy;
		_container.flip.fgrad._rotation = ad;
		_container.flip.fgrad._alpha = (r > (rl - 50)) ? 100 - (r - (rl - 50)) * 2 : 100;
		_container.flip.p3shadow._x = cx;
		_container.flip.p3shadow._y = cy;
		_container.flip.p3shadow._rotation = ad;
		_container.flip.p3shadow._alpha = (r > (rl - 50)) ? 100 - (r - (rl - 50)) * 2 : 100;
		_container.pgrad._x = cx;
		_container.pgrad._y = cy;
		_container.pgrad._rotation = ad + 180;
		_container.pgrad._alpha = (r > (rl - 100)) ? 100 - (r - (rl - 100)) : 100;
		_container.flip.fmask.page._x = pageN._x;
		_container.flip.fmask.page._y = pageN._y;
		_container.flip.fmask.page.pf._x = pageN.pf._x;
		_container.flip.fmask.page.pf._y = pageN.pf._y;
		_container.flip.fmask.page._rotation = pageN._rotation;
	}
	
	private function scalc(obj:Object, m_x:Number):Void {
		//hardflip calc
		if (m_x < -pw) {
			m_x = -pw;
		}
		if (m_x > pw) {
			m_x = pw;
		}
		a = Math.asin(m_x / pw);
		var rot:Number = a / AM / 2;
		var xs:Number = 100;
		var ss:Number = 100 * Math.sin(rotz * AM);
		m_x = m_x / 2;
		m_y = Math.cos(a) * (pw / 2) * (ss / 100);
		placeImg(obj, rot, ss, m_x, m_y);
		_container.pgrad._visible = true;
		_container.flip._visible = true;
		_container.pgrad._xscale = m_x;
		_container.pgrad._alpha = 100;
		_container.flip.p3shadow._alpha = 100;
		_container.flip.p3shadow._xscale = -m_x;
		_container.flip.p3shadow._x = 0;
		_container.flip.p3shadow._y = 0;
		_container.flip.p3shadow._rotation = 0;
		_container.pgrad._x = 0;
		_container.pgrad._y = 0;
		_container.pgrad._rotation = 0;
	}
	
	private function placeImg(j:Object, rot:Number, ss:Number, m_x:Number, m_y:Number):Void {
		var m = Math.tan(rot * AM);
		var f = Math.SQRT2 / Math.sqrt(m * m + 1);
		var phxs = 100 * m;
		var phRot = -rot;
		var xs = 100 * f;
		var ys = 100 * f;
		j.ph.pic._rotation = 45;
		j.ph.pic._xscale = (phxs < 0) ? -xs : xs;
		j.ph.pic._yscale = ys * (100 / ss);
		j.ph._rotation = phRot;
		j.ph._xscale = phxs;
		j._yscale = ss;
		j._x = m_x;
		j._y = m_y;
		j._visible = true;
	}
	private function setPages(p1:Number, p2:Number, p3:Number, p4:Number):Void {
		//attach the right page "image" at the right place:)
		var p0:Number = p1 - 2;
		//_container for transparency...
		var p5:Number = p4 + 2;
		if (p0 < 0) {
			p0 = 0;
		}
		if (p5 > maxpage) {
			p5 = 0;
		}
		if (p1 < 0) {
			p1 = 0;
		}
		//visible _container
		if (p2 < 0) {
			p2 = 0;
		}
		if (p3 < 0) {
			p3 = 0;
		}
		if (p4 < 0) {
			p4 = 0;
		}
		var tLeftInitData:Object={isLeft:true,pageIndex:p1,isOverlay:false,attachName:pageOrder[p1]};
		for (var i in propertyListArray[p1]) {
			tLeftInitData[i]=propertyListArray[p1][i];
		}
		pleft = _container.p1.page.pf.ph.attachMovie(pageOrder[p1], "pic", 0,tLeftInitData);

		_container.p1.page.pf.ph._y = -ph / 2;
		if (transparency) {
			pleftb = _container.p0.page.pf.ph.attachMovie(pageOrder[p0], "pic", 0);
			_container.p0.page.pf.ph._y = -ph / 2;
		} else {
			_container.p0._visible = false;
		}
		if (hflip) {
			//hardflip _container are specials!!! 
			tm = _container.flip.hfliph.attachMovie("sph", "sp2", 0);
			var tLeftOverlayInitData:Object={isLeft:true,isOverlay:true,pageIndex:p2,attachName:pageOrder[p2]};
			for (var i in propertyListArray[p2]) tLeftOverlayInitData[i]=propertyListArray[p2][i];
			sp2 = tm.ph.pic.attachMovie(pageOrder[p2], "pic", 0,tLeftOverlayInitData);
			sp2._y = -ph / 2;
			sp2._x = -pw / 2;
			sp2 = eval("_container.flip.hfliph.sp2");
			
			var tRightOverlayInitData:Object={isLeft:false,isOverlay:true,pageIndex:p3,attachName:pageOrder[p3]};
			for (var i in propertyListArray[p3]) tRightOverlayInitData[i]=propertyListArray[p3][i];
			tm = _container.flip.hfliph.attachMovie("sph", "sp3", 1);
			sp3 = tm.ph.pic.attachMovie(pageOrder[p3], "pic", 0,tRightOverlayInitData);
			sp3._y = -ph / 2;
			sp3._x = -pw / 2;
			sp3 = eval("_container.flip.hfliph.sp3");
			
		} else {
			_container.flip.hfliph.sp2.removeMovieClip();
			_container.flip.hfliph.sp3.removeMovieClip();
			var tLeftOverlayInitData:Object={isLeft:true,isOverlay:true,pageIndex:p2,attachName:pageOrder[p2]};
			for (var i in propertyListArray[p2]) tLeftOverlayInitData[i]=propertyListArray[p2][i];
			sp2 = _container.flip.p2.page.pf.ph.attachMovie(pageOrder[p2], "pic", 0,tLeftOverlayInitData);
			
			_container.flip.p2.page.pf.ph._y = -ph / 2;
			var tRightOverlayInitData:Object={isLeft:false,isOverlay:true,pageIndex:p3,attachName:pageOrder[p3]};
			for (var i in propertyListArray[p3]) tRightOverlayInitData[i]=propertyListArray[p3][i];
			sp3 = _container.flip.p3.page.pf.ph.attachMovie(pageOrder[p3], "pic", 0,tRightOverlayInitData);
			
			_container.flip.p3.page.pf.ph._y = -ph / 2;
		}
		var tRightInitData:Object={isLeft:true,isOverlay:false,pageIndex:p4,attachName:pageOrder[p4]};
		for (var i in propertyListArray[p4]) tRightInitData[i]=propertyListArray[p4][i];
		pright = _container.p4.page.pf.ph.attachMovie(pageOrder[p4], "pic", 0,tRightInitData);
		_container.p4.page.pf.ph._y = -ph / 2;
		if (transparency) {
			prightb = _container.p5.page.pf.ph.attachMovie(pageOrder[p5], "pic", 0,tRightInitData);
			_container.p5.page.pf.ph._y = -ph / 2;
		} else {
			_container.p5._visible = false;
		}
		if (lcover) {
			var lpl = transparency ? p1 - 4 : p1 - 2;
			var lpr = transparency ? p4 + 4 : p4 + 2;
			var limit = transparency ? 0 : -2;
			if (lpl > limit) {
				var tLeftBackPageData:Object={isLeft:true,isOverlay:true,pageIndex:2,attachName:pageOrder[2]};
				for (var i in propertyListArray[2]) tLeftBackPageData[i]=propertyListArray[2][i];
				_container.pLL.page.pf.ph.attachMovie(pageOrder[2], "pic", 0,tLeftBackPageData);
				_container.pLL.page.pf.ph._y = -ph / 2;
				_container.pLL._visible = true;
			} else {
				_container.pLL._visible = false;
			}
			if (lpr < (maxpage - limit)) {
				var tRightBackPageData:Object={isLeft:false,isOverlay:true,pageIndex:maxpage - 1,attachName:pageOrder[maxpage - 1]};
				for (var i in propertyListArray[maxpage - 1]) tRightBackPageData[i]=propertyListArray[maxpage - 1][i];
				_container.pLR.page.pf.ph.attachMovie(pageOrder[maxpage - 1], "pic", 0,tRightBackPageData);
				_container.pLR.page.pf.ph._y = -ph / 2;
				_container.pLR._visible = true;
			} else {
				_container.pLR._visible = false;
			}
		}
	}
	
	private function resetPages():Void {
		setPages(page, 0, 0, page + 1);
	}
	
	private function autoflip():Boolean {
		//start auto flip!
		if (!aflip && !flip && !flipOff && canflip) {
			//only when all conditions fits our needs...
			acnt = 0;
			pmh = ph / 2;
			aamp = Math.random() * pmh - (ph / 4);
			m_x = gflip ? (gdir * pw) / 2 : ((_container._xmouse < 0) ? -pw / 2 : pw / 2);
			m_y = _container._ymouse;
			if (m_y > 0 && m_y > pmh) {
				m_y = pmh;
			}
			if (m_y < 0 && m_y < -pmh) {
				m_y = -pmh;
			}
			oy = m_y;
			sy = m_y;
			ax = (_container._xmouse < 0) ? -pmh : pmh;
			ay = m_y * Math.random();
			//page turnig style randomizing
			offs = -pw;
			hit = 0;
			if (m_x < 0 && page > 0) {
				_container.flip.p3._x = 0;
				hflip = (hcover && gskip) ? (page == maxpage || gtarget == 0) : checkCover(page, -1);
				if (!(preflip && hflip)) {
					if (gskip) {
						setPages(gtarget, gtarget + 1, page, page + 1);
					} else {
						setPages(page - 2, page - 1, page, page + 1);
					}
				}
				hit = -1;
			}
			if (m_x > 0 && page < maxpage) {
				_container.flip.p3._x = pw;
				hflip = (hcover && gskip) ? (page == 0 || gtarget == maxpage) : checkCover(page, 1);
				if (!(preflip && hflip)) {
					if (gskip) {
						setPages(page, gtarget, page + 1, gtarget + 1);
					} else {
						setPages(page, page + 2, page + 1, page + 3);
					}
				}
				hit = 1;
			}
			if (hflip && preflip) {
				hit = 0;
				preflip = false;
				return false;
			}
			if (hit) {
				anim._visible = false;
				flip = true;
				flipOff = false;
				ox = hit * pw;
				sx = hit * pw;
				_container.flip.setMask(_container.mask);
				aadd = hit * (pw / (gflip ? 5 : 10));
				//autoflip takes 10 frames to be done!!!
				aflip = true;
				_container.flip.fmask._x = pw;
				if (preflip) {
					oy = (_container._ymouse < 0) ? -(ph / 2) : (ph / 2);
					sy = (_container._ymouse < 0) ? -(ph / 2) : (ph / 2);
				}
				r0 = Math.sqrt((sy + ph / 2) * (sy + ph / 2) + pw * pw);
				r1 = Math.sqrt((ph / 2 - sy) * (ph / 2 - sy) + pw * pw);
				pageN = eval("_container.flip.p2.page");
				pageO = eval("_container.flip.p3");
				//oef();
				onEnterFrame();
				return true;
			}
		} else {
			return false;
		}
	}
	
	private function getm():Void {
		//get x,y reference points depending of turning style: manual/auto
		if (aflip && !preflip) {
			m_x = ax;
			m_y = ay;
		} else {
			m_x = _container._xmouse;
			m_y = _container._ymouse;
		}
	}
	
	public function gotoPage(i:Number, iskip) {
		trace("Jumping to "+i);
		//quickjump to the page number i
		//i = getPN(i);				//i = target page
		gskip = (iskip == undefined) ? false : iskip;
		//skip _container
		if (i < 0) {
			return false;
		}
		p = int(page / 2);
		d = int(i / 2);
		if (p != d && canflip && !gflip) {
			trace("Page jump here");
			//target!=current page
			if (p < d) {
				//go forward
				gdir = 1;
				gpage = d - p - 1;
			} else {
				//go backward
				gdir = -1;
				gpage = p - d - 1;
			}
			gflip = true;
			if (gskip) {
				gtarget = d * 2;
				gpage = 0;
				autoflip();
				startsnd(0);
				//sound
			}
		} else {
			gskip = false;
		}
	}
	
	/*
	function onEnterFrame():Void
	{
		oef();
	}
	*/
	
	/*
	function getPN(i) {	//get the right page number
	if(i==0){return 0};
	
	var pfind:Boolean = false;
	
	for(j=1;j<=maxpage;j++) {
	if(i==pageNumber[j]) {
	i=j;
	pfind = true;
	break;
	}
	}
	if(pfind){
	return i
	}else{
	return -1;
	}
	}
	*/
	
	private function removePage(i:Number) {
		trace("remove page " + i);
		i = (Math.floor((i - 1) / 2) * 2) + 1;
		removedPages.push(pageNumber[i], pageNumber[i + 1]);
		for (var j:Number = (i + 2); j <= (maxpage + 1); j++) {
			pageOrder[j - 2] = pageOrder[j];
			pageCanTear[j - 2] = pageCanTear[j];
			pageNumber[j - 2] = pageNumber[j];
		}
		trace("removed _container " + i + "," + (i + 1));
		trace(removedPages.join(", "));
		maxpage -= 2;
	}
	
	//-------------------------------------------------------------------------------
	
	private function startsnd(i) { //Sound starter
		if (SoundOn) {
			if (i == 0) {
				snd0.start(0, 0);
				/*
				snd0.onSoundComplete = Delegate.create(this.stardSfunction() {
					startsnd(2);
					delete snd0.onSoundComplete;
					
				}
				*/
			} else {
				i--;
				this["snd" + i].start(0, 0);
			}
		}
	}
	
	//------------------------------------------------------------------------------------------------ PUT YOUR CODE HERE --------------
	/*		you can use these functions:
	
	gotoPage( destinationPageNo, skip );	//quick jump to the page number: destinationPageNo; values = 0-max_container; skip: boolean; if true, _container will be skipped to the destination!
	canflip		//it's a variable. setting its value to false disables flipping
	other functions of page turning is automatic;
	
	WARNING!!!
	if you want to unload/reload tha pageflip, before unloading call function: removeML(); to remove mouse listener!
	*/
	
	function startAutoFlip() {
		intervalID = setInterval(nextPage(), 2000);
		//2 seconds
	}
	function stopAutoFlip() {
		clearInterval(intervalID);
	}
	function prevPage(auto:Boolean) {
		gotoPage(page - 2,auto);
	}
	function nextPage(auto:Boolean) {
		trace("Page turn nextpage ");
		gotoPage(page + 2,auto);
	}
}