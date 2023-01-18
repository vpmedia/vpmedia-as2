
/* ---------- Batch 1.0.0
* 	
	Name : Batch
	Package : eka.src.commands
	Version : 1.0.0
	Date :  2004-12-21
	Author : ekameleon
	URL : http://www.ekameleon.net
	Mail : contact@ekameleon.net
	
	
	STATIC METHODS
	
		process (o, f:Function, a:Array) 
			Exécute une méthode pour une série d'objet contenu dans un tableau
			
			Paramètres :
				o : Context in which to run the function.
				f : fonction à éxécuter.
				a : tableau de paramètres
	
	METHODS
		execute() : exécute toutes les commandes enregistrées.
		addCommand(oCommand) : ajoute une commande.
		removeCommand(oC:Command) : supprime une commande.
		getLength()
		toString()
	
----------  */	

import eka.src.collections.* ;
	
import eka.src.commands.*;

class eka.src.commands.Batch implements SuperCommand {

	// ----o Author Properties

	public static var className:String = "Batch" ;
	public static var classPackage:String = "eka.src.commands";
	public static var version:String = "1.0.0";
	public static var author:String = "ekameleon";
	public static var link:String = "http://www.ekameleon.net" ;
	
	// ----o Private Properties
	
	private var _c:Collection ;
 	
	// ----o Constructor
	
 	public function Batch() {
		_c = new AbstractCollection ;
  	}
	
	// ----o Static Public Methods
  	
	static public function process(o, f:Function, a:Array) : Void {
  		var l:Number = a.length ;
		var aArgs:Array = arguments.splice(3);
		var lArgs:Number = aArgs.length  ;
		while( --l > -1 ) f.apply(o, lArgs>0 ? [a[l]].concat(aArgs) : [a[l]]);
  	}
 	
	// ----o Public Methods
	
 	public function addCommand(oC:Command):Void { _c.addItem(oC) }
  	
  	public function removeCommand(oC:Command):Void { _c.removeItem(oC) }
 
 	public function execute():Void {
		var i:Iterator = _c.getIterator() ;
		while (i.hasNext()) i.next().execute() ;
  	}
  	
  	public function getLength():Number { return _c.size() }
	
	public function toString() : String { return "[Batch]" }
	
}
