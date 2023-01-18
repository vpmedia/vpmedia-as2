/**
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * 
 * 
 * The Initial Developer of the Original Code is
 * DELOISON Matthieu -- www.delfiweb.com.
 * Portions created by the Initial Developer are Copyright (C) 2006-2007
 * the Initial Developer. All Rights Reserved.
 * 
 * Contributor(s) :
 * 
 */

// Classes Delfiweb
import com.delfiweb.ui.AbstractContainer;
import com.delfiweb.display.MovieClipGraphic;
import com.delfiweb.form.AbstractForm;
import com.delfiweb.ui.TxtField;
import com.delfiweb.form.Square;


// Classes Macromedia
import flash.geom.Point;
import flash.geom.Rectangle;


/**
 * todo : 
 * 		- ajouter des effets (tween de Francis Bourre) sur l'apparition et 
 * la disparition du ToolTip.
 * 		- apporter de nouvelles fonctionnalités à la classe, 
 * notamment pour créer une encoche personnalisée ou un autre type d'infosbulle
 *  (en partie déjà possible gràce à AbstractForm)
 * 		- rajouter des méthodes de personnalisation supplémentaires 
 * (exemple le padding, l'arrondi de la bulle...)
 * 
 */


/**
 * Class ToolTip : it's a singleton.
 * It's used to put a message in a movieclip, in a button...
 * For example : onRollOver of Button, ToolTip appairs.
 * 
 * 
 * @note : - to make some multi-ligne text, use "\n" because "<br />" are not correct.
 * I search a better solution.
 * 
 *
 * @usage :
 	var oToolTip:ToolTip = ToolTip.instance;
	var oAbsForm:Square = new Square("SqToolTipD", 20, 20, 15);
	this.setTip(oAbsForm);
	oToolTip.attach(_root, 10000);
	
	
	// show the tooltip
	var oRect:Rectangle = new Rectangle(coord.x, coord.y, _mcBase._width-_nPadding, _mcBase._height-_nPadding);
	ToolTip.open("Hello", oRect);
		
	// hide the tooltip
	ToolTip.close();
	
 *	
 * @author  Matthieu DELOISON
 * @version 0.1
 * @since 01/11/2006 
 */
class com.delfiweb.ui.ToolTip extends AbstractContainer
{
	
	private static var _oInstance:ToolTip;// instance of ToolTip
	
	/* les objets utilisés */
	private var _oForm:AbstractForm;// object AbstractForm used to create ToolTip (Square, Circle, Background).
	private var _oTxtField:TxtField;// text of the ToolTip
	private var _oMcGraphic:MovieClipGraphic;
	
	
	/* caractéristiques du ToolTip */
	private var _nPadding:Number = 5;// margin of the ToolTip
	
	
	
	/**
	 * CONSTRUCTOR
	 * 
	 */
	private function ToolTip()
	{
		super("ToolTip_"+random(100)); // create an AbstractContainer
		
		_oMcGraphic = new MovieClipGraphic();
		this.setDisplayObject(_oMcGraphic);
	}
	


	

/* ***************************************************************************
 * PUBLIC FUNCTIONS
 ******************************************************************************/


	/**
	 * It's used to attach mc at a movieclip put in parameter.
	 * Depth is optionnal, if is the depth is undefined, mc is build at the top depth of parent clip.
	 * 
	 * 
	 * @param   mc 			: movieclip used to build graphic object
	 * @param   d 			: depth of the MovieClip  
	 * @return
	 */
	public function attach(mc:MovieClip,d:Number):Void	
	{
		if(_oForm==undefined)
		{
			var oAbsForm:Square = new Square("SqToolTip", 20, 20, 15);
			this.setTip(oAbsForm);
		}
		
		super.attach(mc, d);// create movieclip _mcBase
		
		_oForm.attach(_mcBase);
		
		var largeurW:Number = _oForm.getWidth();
		var hauteurH:Number = _oForm.getHeight();
		var otxtfield:Object = {background:false, autoSize:true, multiline:false, wordWrap:false};
		var otxtformat:Object = {size:12};		
		
		_oTxtField = new TxtField("", 0, 0, largeurW, hauteurH, otxtfield, otxtformat);
		_oTxtField.attach(_mcBase);
	
		this.hide();// Le ToolTip est par défaut non visible
		return;
	}
	
	
	
	
	/**
	 * Define the graphic used with the ToolTip
	 * 
	 * @param   link 
	 * @return  
	 */
	public function setTip(oAbsForm:AbstractForm)
	{
		_oForm = oAbsForm;
	}
	
	
	
	
	/**
	 * Permet de récupérer l'instance unique du singleton si elle existe
	 * Sinon en créee une
	 * 
	 * @return 
	 */
	public static function get instance():ToolTip
	{
		if(!_oInstance)
		{
			_oInstance = new ToolTip ();
		}
		
		return _oInstance;
	}
	
	
	
	/**
	 * Show the ToolTip with wished text, you can specify a position.
	 * 
	 * @param  msg : html text
	 * @param  oRect : position of ToolTip : oRect.x - oRect.y and the size of object who displaying the ToolTip
	 */
	public static function open(msg:String, oRect:Rectangle)
	{
		// update the text of the ToolTip
		_oInstance._oTxtField.txt = msg;
		
		// update size and position of the tooltip
		resizeBackground();
		
		/* position the ToolTip in function of size of the scene */
		posToolTip(oRect);
		
		// show the ToolTip
		_oInstance.show();
	}
	
	
	
	/**
	 * Hide the ToolTip
	 * 
	 */
	public static function close()
	{
		// si l'infos bulle a été inversé, on la remet dans le même sens d'origine
		if(_oInstance._oForm.getMovieClip()._xscale < 0)
		{
			_oInstance._oForm.getMovieClip()._xscale *= -1;
			_oInstance._oForm.move(0, null);
		}
		
		// supprime le texte, on rénitialise la taille et masque l'infos bulle
		_oInstance._oTxtField.txt = "";
		
		_oInstance._oForm.setWidth(20);
		_oInstance._oForm.setHeight(20);		

		_oInstance.hide();
	}
	

	
	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */
	public static function destruct():Void
	{
		delete _oInstance._oForm;
		delete _oInstance._oTxtField;
	}	
	
	
/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/

	
	/**
	 * Update size and position of the background.
	 * 
	 */
	private static function resizeBackground()
	{
		// ajuste la taille du fond du Tooltip
		_oInstance._oForm.setWidth( _oInstance._oTxtField.getWidth() + 2*_oInstance._nPadding );
		_oInstance._oForm.setHeight( _oInstance._oTxtField.getHeight() + 3*_oInstance._nPadding );
				
		// positionne le txt dans le tooltip
		var oPoint:Object = _oInstance._oForm.getPosition();
		_oInstance._oTxtField.move( oPoint.x+_oInstance._nPadding, oPoint.y+_oInstance._nPadding );
	}
	
	
	
	/**
	 * Move the ToolTip in a correct position.
	 * 
	 * @param  oRect : La position du ToolTip : oRect.x - oRect.y et la taille de l'objet sur lequel s'affiche le tooltip
	 * @return  
	 */
	private static function posToolTip(oRect:Rectangle)
	{
		
		var xTooltip:Number = oRect.x - _oInstance._oForm.getWidth();
		
		// si la bulle dépasse de la scène sur la gauche
		if( xTooltip < 0)
		{
			// inverse la position de la bulle
			if(_oInstance._oForm.getMovieClip()._xscale > 0)
			{
				_oInstance._oForm.getMovieClip()._xscale *= -1;			
				_oInstance._oForm.move( _oInstance._oForm.getWidth(), null);				
			}
			
			// place la bulle dans le coin supérieur droite
			oRect.x += oRect.width; 
			oRect.y -= _oInstance._oForm.getHeight();
			
			// si la bulle dépasse de la scène vers le haut, on la redescend
			if( oRect.y<0 )
			{
				oRect.y = _oInstance._nPadding/2; // évite que la bulle soit collé en haut
			}
			
		}
		
		// sinon positionne la bulle sur le coin supérieur gauche
		else
		{
			var yTooltip:Number = oRect.y - _oInstance._oForm.getHeight();
			
			// si la bulle dépasse de la scène vers le haut, on la redescend
			if( yTooltip<0 )
			{
				oRect.y = _oInstance._nPadding/2; // évite que la bulle soit collé en haut
			}
			else
				oRect.y -= _oInstance._oForm.getHeight();
			
			oRect.x = xTooltip; 
		}
		
		// pos contient les coordonnées de la souris dans le référentiel de la scene.
		// Il faut convertir ces coordonnées dans le référentiel de _mcBase
		//_oInstance._mcBase.globalToLocal(pos); // inutile à priori	
		
		// positionne le ToolTip aux coordonnées définis
		_oInstance.move( oRect.x,  oRect.y)
	}
	
	
	
}// end of class