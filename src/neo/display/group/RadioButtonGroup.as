/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Neo Library.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <contact@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2005
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/

/* ---------- 	RadioButtonGroup

	AUTHOR
	
		Name : RadioButtonGroup
		Package : neo.display.group
		Version : 1.0.0.0
		Date :  2006-02-07
		Author : ekameleon
		URL : http://www.ekameleon.net
		Mail : contact@ekameleon.net
	
	DESCRIPTION
		
		Classe Singleton, permet de définir des groupes pour différents widgets de type RadioButton et d'établir des liens entre eux.
	
	METHOD SUMMARY

		- addButton ( name:String , obj:Object )
			
			DESCRIPTION
			
				Ajoute une instance de la classe RadioButton ou qui en hérite à un groupe ayant pour nom "name"
			
			PARAMS : 
				- name : une chaine de caractère correspondant au nom du groupe
				- obj : une instance de la classe RadioButton (ou classe qui en hérite)
		
		- static getInstance () 
			Description : méthode statique
			Renvoi : une instance unique de la classe RadioButttonGroup
		
		
	 	- setGroupName ( name:String , obj:Object )
			Description : permet de définir le groupe d'un objet de type RadioButton
			Paramètres : 
				- name : une chaine de caractère correspondant au nom du groupe
				- obj : une instance de la classe RadioButton (ou classe qui en hérite)
	
				
		- removeButton ( obj:Object )
			Description : supprime l'existance d'un objet contenu dans un ou plusieurs groupes
			Paramètres : 
				- obj : une instance de la classe RadioButton (ou classe qui en hérite)	
		
		
		- resetGroup(groupName:String)
		
		- selectedItemAt()
		
		- setGroupName()
		
		- unSelect(groupName:String)


----------  */

import com.bourre.events.IEvent;

import neo.display.group.IRadioButtonGroup;
import neo.util.ArrayUtil;

class neo.display.group.RadioButtonGroup implements IRadioButtonGroup {
	
	// ----o Singleton
	
	static private var _instance : RadioButtonGroup ;	
	static public function getInstance () : RadioButtonGroup {
		if (_instance == undefined)  _instance = new RadioButtonGroup () ;
		return _instance ;
	}
	
	// ----o Public Properties
	
	public var groups:Object = new Object ;
	
	// ----o Private Constructor
	
	private function RadioButtonGroup () {}

	// ----o Public Methods
	
	public function addButton( name:String , obj ):Void {
		if (name == undefined || name == "" || obj == undefined ) return ;
		if (groups[name] == undefined) groups[name] = [] ;
		if ( ! ArrayUtil.contains(groups[name], obj) ) {
			groups[name].push (obj) ;	

		}
	}
	
	public function removeButton(obj) : Void {
		for (var i:String in groups) {
			var cur:Array = groups[i] ;
			var n = cur.length ;
			for (var j = 0 ; j<n ; j++) {
				if (cur[j] == obj) { 
					cur.splice (j, 1) ; 
					break ; 
				}
			}
		}
	}

	public function resetGroup (groupName:String):Void {
		groups[groupName] = undefined ;
	}
	
	public function unSelect ( groupName:String ) : Void {
		var list:Array = groups[groupName] ;
		var l:Number = list.length ;
		while (--l > -1) list[l].setSelected (false, true)  ;
	}
	
	public function selectedItemAt (id:Number, groupName:String, noEvent:Boolean) : Void {
		var a:Array = groups[groupName] ;
		var item = a[id] ;
		if (!item.toggle) return ;
		item.selected = true ;
		var l:Number = a.length ;
		for (var i:Number = 0 ; i<l ; i++) {
			var cur = a[i] ;
			if (i != id && cur.toggle) cur.setSelected (false, (!noEvent))  ;
		}
	}
	
	public function setGroupName ( name:String , obj ) : Void {
		if (obj == undefined) return ;
		removeButton(obj) ;
		if (name == undefined || name == "") return ;
		addButton ( name  , obj ); 
	}
	
	public function update(ev:IEvent):Void {
		var target:MovieClip = ev.getTarget() ;
		if ( ! target.getToggle() ) return ;
		var name:String = target.getGroupName() ;
		var aGroup:Array = groups[name] ;
		if ( name != undefined &&  aGroup != undefined) {
			var l:Number = aGroup.length ;
			for (var i:Number = 0 ; i<l ; i++) {
				var cur = groups[name][i] ;
				if (cur != target && cur.getToggle()) if (cur.toggle) cur.setSelected (false, true)  ;
			}
		}
	}
	

}