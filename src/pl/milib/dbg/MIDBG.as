import pl.milib.collection.MIObjects;
import pl.milib.core.supers.MIBroadcastClass;
import pl.milib.core.supers.MIClass;
import pl.milib.core.value.MIBooleanValue;
import pl.milib.core.value.MIValue;
import pl.milib.core.value.MIValueOwner;
import pl.milib.data.info.MIEventInfo;
import pl.milib.data.TextModel;
import pl.milib.dbg.DBGMCSelector;
import pl.milib.dbg.DBGValuesModel;
import pl.milib.dbg.InstanceDebugProvider;
import pl.milib.dbg.MIDBGUtil;
import pl.milib.dbg.window.contents.DBGWindowMCViewContent;
import pl.milib.dbg.window.contents.DBGWindowTextContent;
import pl.milib.dbg.window.DBGClassWindow;
import pl.milib.dbg.window.DBGValuesWindow;
import pl.milib.dbg.window.DBGWindow;
import pl.milib.dbg.window.DBGWindowUI;
import pl.milib.managers.CookiesManager;
import pl.milib.managers.DelayedExecutionsManager;
import pl.milib.managers.HTMLASFunctionsManager;
import pl.milib.managers.KeyManager;
import pl.milib.mc.MCDuplicaton;
import pl.milib.mc.service.MIMC;
import pl.milib.tools.KeyboardShortcut;
import pl.milib.tools.KeyboardShortcuts;
import pl.milib.tools.LoadingObserver;
import pl.milib.util.MILibUtil;
import pl.milib.util.MIMCUtil;

/**
 * @author Marek Brun 'minim'
 */
class pl.milib.dbg.MIDBG extends MIBroadcastClass implements MIValueOwner {
	
	public var event_UILoaded:Object={name:'UILoaded'};
	
	private var keybshcut_visible:KeyboardShortcut;
	private var keybshcut_switchMinimize:KeyboardShortcut;
	private var keybshcut_openProjectClassWindow:KeyboardShortcut;
	private var keybshcut_showRoot:KeyboardShortcut;
	private var keybshcut_wordWrapInTextContent:KeyboardShortcut;	private var keybshcut_selectMC:KeyboardShortcut;	private var keybshcut_closeSelectedWindow:KeyboardShortcut;
	private var keybshcut_setSelectedWindowX0Y0:KeyboardShortcut;
	
	private static var instance : MIDBG;
	private var mc : MovieClip;
	private var mcLoad : LoadingObserver;
	private var mimc : MIMC;
	private var mc_windows : MovieClip;
	private var winDuplication : MCDuplicaton;
	public var dbgMainWindow : DBGWindow;
	private var instanceWindows : MIObjects;//of DBGClassWindow
	private var log : TextModel;
	private var links : HTMLASFunctionsManager;
	private var selectedWindow : MIValue;
	private var windowsUIs : MIObjects;
	private var keyboardShortcuts : KeyboardShortcuts;
	private var areVisible : MIBooleanValue;
	public var cookieData : Object;
	private var km : KeyManager;
	private var dbgmcsel : DBGMCSelector;
	private var dbgValuesWindow : DBGValuesWindow;
	private var values : DBGValuesModel;
	private var cookieDataOpensOrg : Array;
	private var clippoardTexts : Object;
	private var logHistory : TextModel;
	
	private function MIDBG() {
		_root.isDBG=true;
		var x=InstanceDebugProvider;
		x=DBGWindowMCViewContent;
		clippoardTexts={};
		var root:MovieClip=Boolean(_root.dbgMC) ? _root.dbgMC : _root;
		mc=MILibUtil.getMCMILibMC(root).createEmptyMovieClip('forMIDBGManager', MILibUtil.getMCMILibMC(root).getNextHighestDepth());
		var url:String=_root._url;
		if(url.indexOf('file://')>-1){ url=''; }
		else{ url=url.substr(0, url.lastIndexOf('/')+1); }
		mc.loadMovie(url+'midbg.swf');
		mcLoad=new LoadingObserver();
		mcLoad.addListener(this);
		
		log=new TextModel(true, 500);		logHistory=new TextModel(true, 500);
		values=new DBGValuesModel();
		
		keyboardShortcuts=new KeyboardShortcuts();
		keyboardShortcuts.setIsEnabled(true);
		keyboardShortcuts.addListener(this);
		keybshcut_visible=new KeyboardShortcut([KeyManager.KEY_TILDE], KeyManager.KEY_1, 'visible');
		keybshcut_switchMinimize=new KeyboardShortcut([KeyManager.KEY_TILDE], KeyManager.KEY_M, 'minimize');
		keybshcut_openProjectClassWindow=new KeyboardShortcut([KeyManager.KEY_TILDE], KeyManager.KEY_P, 'open project class window');
		keybshcut_showRoot=new KeyboardShortcut([KeyManager.KEY_TILDE], KeyManager.KEY_R, 'show root');
		keybshcut_wordWrapInTextContent=new KeyboardShortcut([KeyManager.KEY_TILDE], KeyManager.KEY_W, 'word wrap in text viewer');		keybshcut_selectMC=new KeyboardShortcut([KeyManager.KEY_TILDE], KeyManager.KEY_M, 'select MC');
		keybshcut_closeSelectedWindow=new KeyboardShortcut([KeyManager.KEY_TILDE], KeyManager.KEY_Q, 'close selected window');
		keybshcut_setSelectedWindowX0Y0=new KeyboardShortcut([KeyManager.KEY_TILDE], KeyManager.KEY_0, 'set selected window X=0, Y=0');
		keyboardShortcuts.addShortcuts([
			keybshcut_visible,
			keybshcut_switchMinimize,
			keybshcut_openProjectClassWindow,
			keybshcut_showRoot,
			keybshcut_wordWrapInTextContent,
			keybshcut_selectMC,
			keybshcut_closeSelectedWindow,
			keybshcut_setSelectedWindowX0Y0
		]);
		
		dbgmcsel=DBGMCSelector.getInstance();
		dbgmcsel.addListener(this);
		
		instanceWindows=new MIObjects();
		instanceWindows.addListener(this);
		
		areVisible=(new MIBooleanValue()).setOwner(this);
		
		windowsUIs=new MIObjects();
		windowsUIs.addListener(this);
		selectedWindow=(new MIValue()).setOwner(this);
		
		DelayedExecutionsManager.addNew(this, openObjectWindow);		DelayedExecutionsManager.addNew(this, tryAutoOpen);
		
		links=HTMLASFunctionsManager.getInstance();
		links.addListener(this);
		
		var cookie=CookiesManager.getCookie('midbgmain');
		if(!cookie.data.d){
			cookie.data.d={
				v:true,
				opened:[],
				windowsProps:{}
			};
		}
		cookieData=cookie.data.d;
		if(!cookieData.windowsProps){ cookieData.windowsProps={}; }
		cookieDataOpensOrg=cookieData.opened.concat();
		km=KeyManager.getInstance();
		
		_root.log=MILibUtil.createDelegate(this, addLogText);
		_root.logv=MILibUtil.createDelegate(this, addValueLog);
		_root.link=MILibUtil.createDelegate(this, link);
		
	}//<>
	
	private function start2(Void):Void {
		mcLoad.startObserve(mc);
	}//<<
	
	private function link(val):String {
		return MIDBGUtil.link(val);
	}//<<
	
	public function openObjectWindow(obj):Void {
		MILibUtil.hideVariables(obj, ['dbg']);
		if(Key.isDown(KeyManager.KEY_CTRL)){
			var selWin:DBGWindow=DBGWindow(selectedWindow.v);
			if(selWin){ 
				var win:DBGWindow=DBGClassWindow.forInstance(obj);
				win.ui.setXY(selWin.ui.mimc.mc._x, selWin.ui.mimc.mc._y);
				win.ui.setWidthAndHeight(
					selWin.ui.getWidth(),					selWin.ui.getHeight()
				);
				selectWindow(DBGClassWindow.forInstance(obj));
				//win.setContentByNumber(selWin.getContentNum());
				selWin.getDeleter().DELETE();
			}else{
				selectWindow(DBGClassWindow.forInstance(obj));
			}
		}else{
			selectWindow(DBGClassWindow.forInstance(obj));
		}
	}//<<
	
	public function tryAutoOpen(obj):Void {
		var ct:String=MIDBGUtil.getObjContextText(obj);
		for(var i=0;i<cookieDataOpensOrg.length;i++){
			if(cookieDataOpensOrg[i]==ct){
				cookieDataOpensOrg.splice(i, 1);
				openObjectWindow(obj);
				DBGClassWindow.forInstance(obj).ui.areMaximized.v=false;
				break;
			}
		}
	}//<<
	
	public function getNewDBGClassWindow(obj):DBGClassWindow {
		var win:DBGClassWindow=new DBGClassWindow(winDuplication.getNewMC(true), obj);
		windowsUIs.addObject(win.ui);
		instanceWindows.addObject(win);
		resetCookieDataOpensOrg();
		if(MILibUtil.getConstructor(obj).DBG_WIN_INI){
			win.setContentByName(MILibUtil.getConstructor(obj).DBG_WIN_INI);
		}
		if(MIDBGUtil.getObjContextText(obj)){
			var objName:String='dbgWindow'+MIDBGUtil.getObjContextText(obj);
			if(!cookieData.windowsProps[objName]){ cookieData.windowsProps[objName]={}; }
			win.setCookie(cookieData.windowsProps[objName]);
		}
		return win;
	}//<<
	
	public function getNewDBGWindow(obj):DBGWindow {
		var win:DBGWindow=new DBGWindow(winDuplication.getNewMC(true));
		windowsUIs.addObject(win.ui);
		instanceWindows.addObject(win);
		return win;
	}//<<
	
	private function selectWindow(win:DBGWindow):Void {
		MIMCUtil.swapDepthToUp(mc._parent);
		selectedWindow.v=win;
	}//<<
	
	public function pasteToClippoard(name:String, text:String):Void {
		if(!clippoardTexts[name]){ clippoardTexts[name]={name:name}; }
		 clippoardTexts[name].text=text;
		 var texts:Array=[];
		 for(var i in clippoardTexts){
		 	texts.push('//clipboard data from '+i+':\n'+clippoardTexts[i].text);
		 }
		 System.setClipboard(texts.join('\n\n'));
	}//<<
	
	/** @return singleton instance of MIDBGManager */
	public static function getInstance(Void):MIDBG {
		if(instance==null){ instance=new MIDBG(); }
		return instance;
	}//<<
	
	public function addLogText(text:String):Void {
		log.addText(text);
	}//<<
	
	public function addObjLogText(text:String, obj:Object):Void {
		log.addTextNoRepeat(MIDBGUtil.link(obj)+": "+text);
	}//<<
	
	public function addObjHistoryLogText(text:String, obj:Object):Void {
		logHistory.addTextNoRepeat(MIDBGUtil.link(obj)+": "+text);
	}//<<
	
	public function addValueLog(name:String, value):Void {
		values.addData(name, value);
	}//<<
	
	private function resetCookieDataOpensOrg(Void):Void {
		cookieData.opened=[];
		var arr:Array=instanceWindows.getArray();
		for(var i=0,ct:String;i<arr.length;i++){
			ct=MIDBGUtil.getObjContextText(DBGClassWindow(arr[i]).getObj());
			if(ct){ cookieData.opened.push(ct); }
		}
	}//<<
	
	public function isUILoaded(Void):Boolean {
		return mcLoad.isLoaded();
	}//<<
	
	static public function start($dbgmc:MovieClip):Void {
		_root.dbgMC=$dbgmc;
		getInstance().start2();
	}//<<
	
//****************************************************************************
// EVENTS for MIDBGManager
//****************************************************************************
	private function onEvent(ev:MIEventInfo) {
		//super.onEvent(ev);
		switch(ev.hero){
			case mcLoad:
				switch(ev.event){
					case mcLoad.event_AllBytesLoaded:
						mc._visible=false;
					break;
					case mcLoad.event_RunningFinish:
						MIMCUtil.swapDepthToUp(mc._parent);
						mc._visible=true;
						mimc=MIMC.forInstance(mc);
						mc_windows=mimc.g('a.windows');
						winDuplication=new MCDuplicaton(mc_windows.ele0);
						MIMCUtil.disableMC(mc_windows.ele0);
						dbgMainWindow=new DBGWindow(winDuplication.getNewMC());
						DBGWindowTextContent.forInstance(log).name='log';
						DBGWindowTextContent.forInstance(logHistory).name='history log';
						dbgMainWindow.setupDBGContents([
							DBGWindowTextContent.forInstance(log),
							DBGWindowTextContent.forInstance(logHistory)
						]);
						if(!cookieData.dbgMainWindow){ cookieData.dbgMainWindow={}; }
						dbgMainWindow.setCookie(cookieData.dbgMainWindow);
						windowsUIs.addObject(dbgMainWindow.ui);
						dbgMainWindow.ui.disableCloseButton();
						dbgMainWindow.ui.drawTitle('MIDBG');
						
						dbgValuesWindow=new DBGValuesWindow(winDuplication.getNewMC(), values);
						if(!cookieData.dbgValuesWindow){ cookieData.dbgValuesWindow={}; }
						dbgValuesWindow.setCookie(cookieData.dbgValuesWindow);
						windowsUIs.addObject(dbgValuesWindow.ui);
						dbgValuesWindow.ui.disableCloseButton();
						
						DelayedExecutionsManager.flush(this, openObjectWindow);						DelayedExecutionsManager.flush(this, tryAutoOpen);
						
						selectWindow(dbgMainWindow);
						
						areVisible.v=cookieData.v;
						
						bev(event_UILoaded);
					break;
				}
			break;
			case links:
				switch(ev.event){
					case links.event_LinkPress:
						var obj=ev.data.data;
						switch(ev.data.id){
							case MIDBGUtil.LINKDBGID_Array:
								addLogText(MIDBGUtil.stringifyArray(obj));
							break;
							case MIDBGUtil.LINKDBGID_Object:
								if(obj instanceof MIClass){
									openObjectWindow(obj);
								}else{
									addLogText(MIDBGUtil.stringifyObject(obj));
								}
							break;
							case MIDBGUtil.LINKDBGID_MovieClip:
								openObjectWindow(MIMC.forInstance(obj));
							break;
							case MIDBGUtil.LINKDBGID_String:
								System.setClipboard(obj);
								addLogText('string pasted to clipboard');
							break;
						}
					break;
				}
			break;
			case windowsUIs:
				var hero:DBGWindowUI=DBGWindowUI(ev.data.hero);
				switch(ev.data.event){
					case hero.event_PressWhenDisabled:
						selectWindow(hero.getOwner());
					break;
				}
			break;
			case keyboardShortcuts:
				switch(ev.event){
					case keyboardShortcuts.event_ShortcutPress:						
						switch(ev.data){
							case keybshcut_visible:
								areVisible.sWitch();
							break;
							case keybshcut_switchMinimize:
								//areMinimze.svitch();
							break;
							case keybshcut_openProjectClassWindow:
								openObjectWindow(MILibUtil.getRootClass());
							break;
							case keybshcut_showRoot:
								addLogText('_root>'+MIDBGUtil.link(_root));
							break;
							case keybshcut_wordWrapInTextContent:
								//textViewer.switchWorldWrap();
							break;
							case keybshcut_selectMC:
								dbgmcsel.areEnabled.v=true;
							break;
							case keybshcut_closeSelectedWindow:
								if(selectedWindow.v){
									DBGWindow(selectedWindow.v).ui.close();
								}
							break;
							case keybshcut_setSelectedWindowX0Y0:
								DBGWindow(selectedWindow.v).ui.mimc.mc._x=0;								DBGWindow(selectedWindow.v).ui.mimc.mc._y=0;
							break;
						}
					break;
				}
			break;
			case dbgmcsel:
				switch(ev.event){
					case dbgmcsel.event_KeyUpWhenEnabled:
						dbgmcsel.areEnabled.v=false;
					break;
					case dbgmcsel.event_MouseDownWhenEnabled:
						openObjectWindow(MIMC.forInstance(dbgmcsel.getCurrentMC()));
					break;
				}
			break;
			case instanceWindows:
				var hero:DBGWindow=DBGWindow(ev.data.hero);
				switch(ev.data.event){
					case hero.event_Deleted:
						resetCookieDataOpensOrg();
					break;
				}
			break;
		}
	}//<<Events
	
	public function onSlave_MIValue_ValueChange(val:MIValue, oldValue):Void {
		switch(val){
			case selectedWindow:
				DBGWindow(oldValue).ui.areSelected.v=false;
				DBGWindow(selectedWindow.v).ui.areSelected.v=true;
				MIMCUtil.swapDepthToUp(DBGWindow(selectedWindow.v).ui.mimc.mc);
			break;
			case areVisible:
				mc._visible=areVisible.v;
				cookieData.v=areVisible.v;
			break;
		}
	}//<<

}