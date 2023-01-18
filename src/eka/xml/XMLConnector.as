

/* ---------- Class XMLConnector

	Name : XMLConnector
	Package : eka.xml
	Version : 1.1.0
	Author : ekameleon
	Date : 2004-09-25
	
	VIRTUAL PROPERTIES
	- url:String : url du fichier sur le serveur
	- cache:Boolean : active ou désactive le cache du fichier à récupérer
	- direction:String : "receive", "send", "send/receive" , type de connection
	- params:Object : objet dont toutes les propriétés seront envoyées vers le script PHP côté server.
	
	PUBLIC METHODS
		- trigger () : Déclenche la connexion
		- checkData () : fonction qui doit être surchargée pour analyser le xml reçu.
		- addEventListener () 
		- removeEventListener ()
	
	EVENT
		- onLoadSuccess () 
			Invoqué quand un xml est bien chargé
	
		- onLoadError ()
			Invoqué quand le chargement renvoi une erreur
			item.info : renvoi un message d'erreur correspondant à l'erreur produite.
	
---------- */ 

import eka.src.commands.* ;
import eka.src.events.type.* ;

class eka.xml.XMLConnector extends XMLGDispatcher implements Command {

	// ----o Author Properties
	
	public static var className:String= "XMLConnector" ;
	public static var classPackage:String= "eka.xml";
	public static var version:String= "1.1.0";
	public static var author:String= "ekameleon";
	public static var link:String= "http://www.ekameleon.net" ; 
	
	// ---- CONSTRUCTOR
	
	public function XMLConnector (str:String) { 
		super (str) ;
		_init() ;
	}

	// ----o Public Properties
	
	public var ignoreWhite:Boolean = true ;

	// ---- PUBLIC METHODS
	
	public function initialize(Void):Void {
		// 
	}
	
	public function checkData(event):Void {
		//
	}

	public function trigger() : Void {
		execute() ;
	}
	
	public function execute():Void {
		switch (_nD) {
			case 0 :
				load (_sU) ;
				break ;
			case 1 :
				send (_sU) ;
				break ;
			case 2 :
				_lvS.sendAndLoad (_sU, this) ;
				break ;
			default :
				return ;
		} 
	}
	 
	public function updateLoadSuccess(Void):Void {
		updateEvent("onLoadSuccess") ;
	}
	 
	public function updateLoadError(event:String):Void {
		updateEvent("onLoadError" , { info:event } ) ;
	}

	// ---- GETTER / SETTER METHODS
	
	public function get_URL () { return _sU }
	public function set_URL (str:String) { _sU = str }

	public function getParams () : Object {
		var o:Object = {} ;
		for (var i in _lvS) o[i] = _lvS[i] ;
		return o ;
	}	
	
	public function setParams (o:Object) : Void {
		_lvS = new LoadVars () ;
		for (var i in o) _lvS[i] = o[i] ;
	} 
	
	public function getDirection () : String {
		var a:Array = ["receive", "send", "send/receive"] ;
		return a[_nD] ;
	}	
	public function setDirection ( str : String) :Void {
		switch (str.toLowerCase()) {
			case "receive" :
				_nD = 0 ;
				break ;
			case "send" :
				_nD = 1 ;
				break ;
			case "send/receive" :
				_nD = 2 ;
				break ;
			default :
			_nD = 0 ;
		}
	} 
   
	public function getCache () : Boolean { return _bC }
	public function setCache ( bool:Boolean) : Void {
		if (_bC == bool) return ;
		(bool) ? _sU += "?cache=" + new Date() : _sU = _sU.split ("?")[0]  ;
		_bC = bool ;
	} 

	// ---- VIRTUAL PROPERTIES
	
	public function get url () { return get_URL () }
	public function set url (str:String) { set_URL (str) }

	public function get direction () { return getDirection () }
	public function set direction (str : String) { setDirection (str) }	 

	public function get cache () : Boolean { return getCache() }
	public function set cache ( bool:Boolean) : Void { setCache (bool) }

	public function get params () : Object { return getParams() }
	public function set params (o:Object) : Void { setParams(o) }

	// ----o Private Properties

	private var _sU:String ; // xml url
	private var _bC:Boolean ; // cache
	private var _lvS:LoadVars ; // 
	private var _nD:Number = 0 ; 
		
	// ---- PRIVATE METHODS
	
	private function _init(Void):Void {
		addEventListener("onLoadSuccess", this, "checkData") ;
		initialize() ;
	}
	
	private function onLoad ( success : Boolean ) : Void  {
		if (success) (status == 0) ? updateLoadSuccess() : updateLoadError("xml non valide") ;
		else updateLoadError("connection error") ;
	}
 
}
