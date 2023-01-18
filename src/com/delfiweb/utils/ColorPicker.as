

// delfiweb
import com.delfiweb.ui.AbstractContainer;
import com.delfiweb.display.MovieClipGraphic;


// bourre
import com.bourre.commands.Delegate;


// debug
import com.bourre.log.Logger;




/**
 * @author Aggelos _ http://www.aggelos.org/index.php?2005/01/17/11-as2-un-ptit-selecteur-de-couleurs
 * @update Matthieu DELOISON
 * @since 18 Juillet 2007
 * 
 */
class com.delfiweb.utils.ColorPicker extends AbstractContainer
{
	
/* ****************************************************************************
 * PRIVATE VARIABLES
 *******************************************************************************/
	
	/* movieclip */
	private var _mcColor		: MovieClip;
	private var _mcPicker		: MovieClip;
	
	
	/* config */
	private var _aColorSpace	: Array = ["00","33","66","99","CC","FF"];
	private var _aFavoriteCols	: Array = ["FFFFFF,000000,0033FF,FFFFFF,FFFFFF,FFFFFF"];
	private var _nDefaultColor	: Number = 0xCCCCCC;// default selected color
	private var _nCurrentColor	: Number;// current selected color
	private var _nOverColor 	: Number;
	
	private var _nDepth 		: Number;


	/* objects */
	private var _oMcGraphic 	: MovieClipGraphic;
	private var _oColor			: Color;
	
	
	/* config color */
	private var _nWidthtPicker	: Number;
	private var _nHeightPicker	: Number;

	
	
/* ****************************************************************************
 * CONSTRUCTOR
 **************************************************************************** */

	public function ColorPicker(x:Number, y:Number, w:Number, h:Number)
	{
		super("ColorPicker_"+random(1000), x, y); // création d'un AbstractContainer
		_nDepth = 10;
		
		_nWidthtPicker = w ? w : 20;
		_nHeightPicker = h ? h : 20;
		
		_nWidth = _nWidthtPicker;
		_nHeight = _nHeightPicker;
		
		_oMcGraphic = new MovieClipGraphic();
		this.setDisplayObject(_oMcGraphic);
	}
	
	
	/**
	 * Set the selected color of the picker.
	 * 
	 */
	public function setColor(nColor:Number):Void
	{
		_oColor.setRGB(nColor);
	}
	
	
	/**
	 * Destroy all ressources used by instance of class.
	 * 
	 * @return Boolean
	 */	
	public function destruct():Boolean
	{
		Mouse.removeListener(this);
		return super.destruct();	
	}
	
	
/* ****************************************************************************
 * PRIVATE FUNCTIONS
 *******************************************************************************/

	/**
	 * Called by class AbstractContainer when object is drawing.
	 * 
	 * @return  
	 */
	private function endBuilding()
	{	
		_mcColor = _mcBase.createEmptyMovieClip("__ColorPicker__", _nDepth++);
		
		/* selected color */
		_mcColor.beginFill(_nDefaultColor);
		_mcColor.moveTo(0, 0);
		_mcColor.lineTo(_nWidthtPicker, 0);
		_mcColor.lineTo(_nWidthtPicker, _nHeightPicker);
		_mcColor.lineTo(0, _nHeightPicker);
		_mcColor.lineTo(0, 0);
		_mcColor.endFill();
		
		_mcColor.onRelease = Delegate.create(this,_showPicker);
		
		// border
		var mc:MovieClip = _mcBase.createEmptyMovieClip("mcBorderPicker", _nDepth++);
		mc.lineStyle(1,0,100);
		mc.beginFill( 0xffffff, 0);
		mc.lineTo(_nWidthtPicker, 0);
		mc.lineTo(_nWidthtPicker, _nHeightPicker);
		mc.lineTo(0, _nHeightPicker);
		mc.lineTo(0,0);
		mc.endFill();
		
		_oColor = new Color(_mcColor);
		_oColor.setRGB(_nDefaultColor);
		
		_nCurrentColor = _nDefaultColor;
		
		/* picker of colors */
		_mcPicker = _mcBase.createEmptyMovieClip("mcPicker", _nDepth++);
		_mcPicker._y = _nHeightPicker;
		_mcPicker._x = 0;
		_mcPicker._visible = false;
		
		this.buildPicker();
		this._onSelectColor();
		
		Mouse.addListener(this); 
	}
	
	
	private function _showPicker():Void
	{
		_mcPicker._visible = true;
	}
	
	private function _hidePicker():Void
	{
		_mcPicker._visible = false;
	}
	
	private function createCell (i:Number,j:Number,color:String) 
	{
		var mc:MovieClip = _mcPicker.createEmptyMovieClip("color_"+i+j,_mcPicker.getNextHighestDepth());
		
		mc._x = (i*10);
		mc._y = (j*10);
		
		mc.lineStyle(1,0,100);
		mc.beginFill(Number(color),100);
		mc.lineTo(10,0);
		mc.lineTo(10,10);
		mc.lineTo(0,10);
		mc.lineTo(0,0);
		mc.endFill();
		
		var oDelegate:Delegate = new Delegate(this, _onRollOver, color);
		mc.onRollOver = oDelegate.getFunction();
		mc.onRollOut = Delegate.create(this, _onRollOut);	
		mc.onRelease = Delegate.create(this, _onSelectColor);	
	}


	private function _onRollOver(nColor:Number):Void
	{
		_oColor.setRGB(nColor);
		_nOverColor = nColor;
	}
	
	private function _onRollOut():Void
	{
		_oColor.setRGB(_nCurrentColor);
	}
	
		
	private function _onSelectColor():Void
	{
		_nCurrentColor = _nOverColor;
		_oColor.setRGB(_nCurrentColor);
		
		this._oEventManager.broadcastEvent("_onColorSelected", _nCurrentColor);
		_hidePicker();
	}
	

	private function buildPicker() 
	{
		var i:Number;		var j:Number;		var k:Number;
		
		for(i=0;i<3;i++) 
		{
			for(j=0;j<6;j++) 
			{
				for(k = 0;k<6;k++) 
				{
					createCell(6*i+j,k,"0x"+_aColorSpace[i]+_aColorSpace[j]+_aColorSpace[k]);
				}
			}
		}
		
		for(i=3;i<6;i++) 
		{
			for(j=0;j<6;j++) 
			{
				for(k = 0;k<6;k++) 
				{
					createCell(6*(i-3)+j,6+k,"0x"+_aColorSpace[i]+_aColorSpace[j]+_aColorSpace[k]);
				}
			}
		}
		
		for(i=0;i<6;i++) 
		{
			createCell(18,i,"0x"+_aColorSpace[i]+_aColorSpace[i]+_aColorSpace[i]);
			createCell(18,i+6,"0x"+_aFavoriteCols[i]);
		}
	}
	
	
	
	/**
	 * Call by Mouse.
	 * Hide picker.
	 * 
	 * @see     
	 * @return  
	 */
	private function onMouseDown ():Void
	{
		/* détermine les coordonnées de la souris au niveau du clip de base */
		var oSouris:Object = {x:_mcPicker._xmouse, y:_mcPicker._ymouse};	
		
		if( oSouris.x < _mcPicker._x || oSouris.x > this._mcPicker._width
		 || oSouris.y < (_mcPicker._y-_nHeightPicker) || oSouris.y > this._mcPicker._height )
			this._hidePicker();

		return;
	}
		
}// end of class