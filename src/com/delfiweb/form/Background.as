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
import com.delfiweb.form.AbstractForm;
import com.delfiweb.display.MovieClipGraphic;
import com.delfiweb.utils.ManageFunction;


// Classes Macromedia
import flash.geom.Rectangle;
import com.bourre.log.Logger;



/**
 * Background is used to load a picture, swf.
 * This class add some method on picture, swf.
 * 
 * 
 * 
 * @usage
	var oBack:Background = new Background ("background.jpg", 0, 0);
	oBack.attach(_root);
 * 
 * @author Matthieu DELOISON
 * @version 0.1
 * @since 11/01/2007
 */
class com.delfiweb.form.Background extends AbstractForm
{	
	
	/* object used */
	private var _oMcGraphic		: MovieClipGraphic;
	


    /**
     * CONSTRUCTOR
	 * 
     * @param l		link of background
	 * 
     */
    public function Background(l:String, x:Number, y:Number, w:Number, h:Number)
    {
		super("Background_"+random(1000), x, y); // create an AbstractForm
		
		this._nWidth = w ? w : 0;
		this._nHeight = h ? h : 0;
		
		_oMcGraphic = new MovieClipGraphic(l);
		this.setDisplayObject(_oMcGraphic);
    }


/* ***************************************************************************
 * PUBLIC FUNCTIONS
 ******************************************************************************/

	

	/**
	 * Return a copy of current object.
	 * 
	 * @return  a copy of current object.
	 */
	public function clone ():Background
	{
		return new Background ( _oMcGraphic.getLink(), _nX, _nY );
	}
	
	



/* ***************************************************************************
 * PRIVATE FUNCTIONS
 ******************************************************************************/


	/**
	 * Called by class AbstractForm when object is drawing
	 * 
	 * @return  
	 */
	private function endBuilding()
	{
		this.updateSize();
	}
	
		
	private function updateSize()
	{
		this._nWidth = this._mcBase._width;
		this._nHeight = this._mcBase._height;
	}
	

}//end Background