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


/* ------- StageLocalizer



	AUTHOR

		

		Name : StageLocalizer

		Package : neo.display

		Version : 1.0.0.0

		Date :  2006-02-06

		Author : ekameleon

		URL : http://www.ekameleon.net

		Mail : contact@ekameleon.net



	DESCRIPTION :



		Classe statique. Permet de définir la position d'un point selon 

		le référentiel défini par la propriété Stage.align courante.



	STATIC PROPRERTIES



		- WIDTH : propriété en lecture seule. Retourne la largeur initiale de la scène principale.



		- HEIGHT : propriété en lecture seule. Retourne la hauteur initiale de la scène principale.





	STATIC METHODS :

	

		- static getMiddle():Point

		

			Renvoi un point ayant pour coordonnées x et y le centre de la scène.

	

		- static localizePoint(p:Point):String

		

			Description : Méthode statique.

				Cette méthode renvoie une chaine de caractère

				Retourne la position d'un point dans la scène principale en fonction du référentiel courant défini par la propriété Stage.align.



			argument : un objet définissant un point de coordonnée x et y.

			renvoi :

				- "B" : Bottom

				- "T" : Top

				- "L" : Left

				- "R" : Right

				- "TL" : Top Left

				- "TR" : Top Right

				- "BL" : Bottom Left

				- "BR" : Bottom Right

				- "" : Center

				

		- static getMirror(align:String) : String

			Decription : renvoi la position mirroir dans la scène d'une position donnée.

			Exemple :

				- "T" renvoi "R" ;

				- "B" renvoi "T" ;

				- "TR" renvoi "BL" ;

				- "TL" renvoi "BR" ;

				- "BR" renvoi "TL" ;

				- "BL" renvoi "TR" ;

				- "L" renvoi "R" ;

				- "R" renvoi "L" ;

				- "" renvoi "" ;



		- static getVerticalMirror(p:Point):String

		

		

	TODO vérifier getVerticalMirror !!

	

----------------*/

import com.bourre.structures.Point;

import neo.display.StageAlign;

class neo.display.StageLocalizer {

	// ----o Constructor

	private function StageLocalizer () {
		//
	}

	// ----o INIT

	static public var WIDTH = Stage.width ;
	static public var HEIGHT = Stage.height ;

	// ----o Public Methods

	static public function localizePoint(p):String {
		var middle:Point = getMiddle() ;
		var x1:Number = p.x ;
		var y1:Number = p.y ;
		var x2:Number = middle.x ;
		var y2:Number = middle.y ;
		if (x1 > x2 && y1 > y2) return StageAlign.BOTTOM_RIGHT ;
		else if (x1 < x2 && y1 > y2 ) return StageAlign.BOTTOM_LEFT ;
		else if (x1 > x2 && y1 < y2) return StageAlign.TOP_RIGHT ;
		else if (x1 < x2 && y1 < y2 ) return StageAlign.TOP_LEFT ;
		else if (x1 == x2 && y1 > y2) return StageAlign.BOTTOM ;
		else if (x1 == x2 && y1 < y2 ) return StageAlign.TOP ;
		else if (x1 < x2 && y1 == y2 ) return StageAlign.LEFT ;
		else if (x1 > x2 && y1 == y2 ) return StageAlign.RIGHT ;
		else return StageAlign.CENTER ;
	}

	static public function getMiddle():Point {
		var middle:Point = new Point(0, 0) ;
		switch (Stage.align) {
			case StageAlign.BOTTOM : // bottom
				middle.x = WIDTH / 2 ;
				middle.y = -  ((Stage.height / 2) - HEIGHT)  ;
				break ;
			case StageAlign.BOTTOM_LEFT : // bottom left
				middle.x = Stage.width / 2 ;
				middle.y = -  ((Stage.height / 2) - HEIGHT)  ;
				break ;
			case StageAlign.BOTTOM_RIGHT : // bottom right
				middle.x =  - (Stage.width - WIDTH) + Stage.width  / 2   ;
				middle.y = -  ((Stage.height / 2) - HEIGHT)  ;
				break ;
			case StageAlign.LEFT : // left
				middle.x = Stage.width / 2 ;
				middle.y = HEIGHT / 2  ;
				break ;
			case StageAlign.RIGHT : // right
				middle.x =  - (Stage.width - WIDTH) + Stage.width  / 2   ;
				middle.y = HEIGHT / 2  ;
				break ;
			case StageAlign.TOP : // top
				middle.x = WIDTH / 2 ;
				middle.y = Stage.height / 2 ;
				break ;
			case StageAlign.TOP_LEFT : // top left
				middle.x = Stage.width / 2 ;
				middle.y = Stage.height / 2 ;
				break ;
			case StageAlign.TOP_RIGHT : // top right
				middle.x =  - (Stage.width - WIDTH) + Stage.width  / 2   ;
				middle.y = Stage.height / 2 ;
				break ;
			default : 
				middle.x = WIDTH / 2 ;
				middle.y = HEIGHT / 2 ;
		}
		return middle ;
	}

	static public function getMirror(align:String):String {
		switch (align.toUpperCase()) {
			case StageAlign.TOP : return StageAlign.BOTTOM ;
			case StageAlign.BOTTOM : return StageAlign.TOP ;
			case StageAlign.TOP_RIGHT : return StageAlign.BOTTOM_LEFT ;
			case StageAlign.TOP_LEFT : return StageAlign.BOTTOM_RIGHT ;
			case StageAlign.BOTTOM_RIGHT : return StageAlign.TOP_LEFT ;
			case StageAlign.BOTTOM_LEFT : return StageAlign.TOP_RIGHT ;
			case StageAlign.LEFT : return StageAlign.RIGHT ;
			case StageAlign.RIGHT : return StageAlign.LEFT ;
			default : return StageAlign.CENTER ;
		}
	}

	static public function getVerticalMirror(point):String {
		var align:String = localizePoint(point) ;
		switch (align.toUpperCase () ) {
			case StageAlign.TOP_RIGHT : return StageAlign.BOTTOM_RIGHT ;
			case StageAlign.TOP_LEFT : return StageAlign.BOTTOM_LEFT ;
			case StageAlign.BOTTOM_RIGHT : return StageAlign.TOP_RIGHT ;
			case StageAlign.BOTTOM_LEFT : return StageAlign.TOP_LEFT ;
			case StageAlign.LEFT : return StageAlign.RIGHT ;
			case StageAlign.RIGHT : return StageAlign.LEFT ;
			default : return StageAlign.CENTER ;
		}
	}

}