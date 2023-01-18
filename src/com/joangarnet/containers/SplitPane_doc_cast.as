import mx.utils.Delegate;
import mx.core.UIComponent;
import mx.containers.ScrollPane;
import mx.styles.CSSStyleDeclaration;
import com.carlosrovira.managers.CursorManager;

// TAB size used in this file = 5

[IconFile("icon/SplitPane_icon.png")]
[TagName("SplitPane")]
[Event("paneExpanded")]

/**
 * Class: SplitPane
 * 
 * author Joan Garnet (<http://www.joangarnet.com>)
 * 
 * version 1.0
 * 
 * extends UIComponent
 * 
 * date 2005/7/22
 */
class com.joangarnet.containers.SplitPane extends UIComponent
{
	/*
	 * Variables
	 */
	// used by createClassObject() method
	public static var symbolName:String 	= "com.joangarnet.containers.SplitPane";
	public static var symbolOwner:Object 	= com.joangarnet.containers.SplitPane; 
	// used by the getStyle() method
	private var className:String 		= "SplitPane";  
	
	/*
	 * Variable: HORIZONTAL_SPLIT
	 * 
	 * Solo lectura. constante que contiene el valor a asignar para asignar orientación horizontal al SplitPane.  El valor numérico es 1.
	 * 
	 * See also:
	 * 
	 * 	<VERTICAL_SPLIT>, <orientation>
	 */	
	static var HORIZONTAL_SPLIT			:Number 	= 1;
	/*
	 * Variable: VERTICAL_SPLIT
	 * 
	 * Solo lectura. constante que contiene el valor a asignar para asignar orientación vertical al SplitPane.  El valor numérico es 2.
	 * 
	 * See also:
	 * 
	 * 	<HORIZONTAL_SPLIT>, <orientation>
	 */	
	static var VERTICAL_SPLIT			:Number 	= 2;

	private var __orientation			:Number;
	private var __dividerSize			:Number;
	private var __dividerLocation 		:Number;
	private var __lastDividerLocation 		:Number;
	private var __maximumDividerLocation 	:Number;
	private var __minimumDividerLocation 	:Number;
	private var __width 				:Number;
	private var __height 				:Number;
	private var cursorId				:Number;
	private var expansionDirectionIncr 	:Number;
	
	private var __oneTouchExpandable 		:Boolean;
	private var __dividerExpanded 		:Boolean;
	private var throwPaneExpandedEvent 	:Boolean;
	
	private var cursorLinkage 			:String;
	private var __expansionDirection 		:String;
	
	private var pane1 					:Object;
	private var pane2					:Object;
	
	private var boundingBox 				:MovieClip;
	private var dividerBar				:MovieClip;		
	private var dividerControl			:MovieClip;
	private var fakeBar 				:MovieClip;
	private var disabler 				:MovieClip; 



	
	/*
	 * Initialisation 
	 */
	public function SplitPane (){}
	
	private function init (Void):Void
	{
		super.init();
		boundingBox._visible 	= false;
		boundingBox._width 		= boundingBox._height = 0;
		boundingBox._x 		= boundingBox._y = -5000;
		minimumDividerLocation 	= 15;
		maximumDividerLocation 	= 40;		
		dividerSize 			= 6;
		dividerLocation 		= 25;
		expansionDirectionIncr 	= 0;
		// why do I have to initialize Inspectable properties ????
		orientation 			= SplitPane.VERTICAL_SPLIT;
		oneTouchExpandable 		= true;
		lastDividerLocation 	= dividerLocation;
		__expansionDirection 	= "rightLeft";
		throwPaneExpandedEvent 	= false;
		dividerExpanded 		= true;
		addEventListener 		( "paneExpanded", this );
		// default SplitPane styles
		var styleObj 					= new mx.styles.CSSStyleDeclaration();
		styleObj.styleName 				= "SplitPane"; 
		_global.styles.SplitPane 		= styleObj;
		styleObj.setStyle 				( "controlOverColor", 0xE0DFE3 );
		styleObj.setStyle 				( "controlOutColor",  0xBFC3C3 );		
		styleObj.setStyle 				( "arrowOverColor",   0x000000 );
		styleObj.setStyle 				( "arrowOutColor",    0xffffff );
		styleObj.setStyle 				( "dividerBarColor",  0x717878 );
		// disabled state styles
		styleObj.setStyle 				( "controlDisabledColor",    0xF7F7F7 );
		styleObj.setStyle 				( "arrowDisabledColor",      0xDDDDDD );
		styleObj.setStyle 				( "dividerBarDisabledColor", 0xDDDDDD );
		// do set styles
		setStyle 						( "styleName", "SplitPane" );
	}
	
	private function createChildren (Void):Void
	{
		createClassObject 		( ScrollPane, "pane1", 1, {_visible:false} );
		createClassObject 		( ScrollPane, "pane2", 2, {_visible:false} );
		createDividers 		();
		pane1.setStyle 		( "backgroundColor", 0xffffff);
		pane2.setStyle 		( "backgroundColor", 0xffffff);
		pane1.owner 			= this;
		pane2.owner 			= this;
		dividerBar._visible 	= false;
		dividerControl._visible 	= false;
	}
	
	/**
	 * Creates the split bar and the "one touch expand" control button
	 */
	private function createDividers (Void):Void
	{
		if ( orientation == SplitPane.HORIZONTAL_SPLIT )
		{
			createObject 			( "divider_bar_h", "dividerBar", 3 );
			createObject 			( "divider_control_h", "dividerControl", 4 );
		}
		else if ( orientation == SplitPane.VERTICAL_SPLIT )
		{
			createObject 			( "divider_bar_v", "dividerBar", 3 );
			createObject 			( "divider_control_v", "dividerControl", 4 );
		}
		dividerBar._visible 	= false;
		dividerControl._visible 	= false;
	}
	
	
	
	
	/*
	 * GETTER / SETTER
	 */
	[Inspectable(defaultValue="VERTICAL_SPLIT", enumeration="HORIZONTAL_SPLIT,VERTICAL_SPLIT", category="Behaviour")]
	public function get orientation ():Number
	{
		return __orientation;
	}
	/*
	 * Property: orientation
	 * 
	 * Getter/setter.  Determina si el SplitPane se divide vertical o horizontalmente.
	 * (start code)
	 * // using the static property
	 * mySplitPane.orientation = SplitPane.HORIZONTAL_SPLIT;
	 * // using a string
	 * mySplitPane.orientation = "VERTICAL_SPLIT";
	 * (end)
	 * 
	 * Parameters:
	 * 
	 * 	_orientation - Puede ser un String o un Number.  
	 * 				Valores válidos son "HORIZONTAL_SPLIT" o SplitPane.HORIZONTAL_SPLIT, "VERTICAL_SPLIT" o SplitPane.VERTICAL_SPLIT.
	 * 
	 * Returns:
	 * 
	 * 	Un Number.  Puede ser 1 (SplitPane.HORIZONTAL_SPLIT) o 2 (SplitPane.VERTICAL_SPLIT).
	 * 
	 * See Also:
	 * 
	 * 	<HORIZONTAL_SPLIT>, <VERTICAL_SPLIT>
 	 */
	public function set orientation ( _orientation )
	{
		if ( typeof _orientation == "string" )
		{
			__orientation = SplitPane[_orientation];
		}
		else if ( typeof _orientation == "number" )
		{
			__orientation = _orientation;
		}
		else
		{
			error ( "new badOrientationValueException ()" );
			return;
		}
		setCursor ();
		invalidate ();
	}	
	
	[Inspectable(defaultValue=true, category="Behaviour")]
	public function get oneTouchExpandable ():Boolean
	{
		return __oneTouchExpandable;
	}
	/*
	 * Property: oneTouchExpandable
	 * 
	 * Getter/setter.  Determina si el divider del SplitPane tiene un control para expandir / contraer y, cuando es asignado, 
	 * también ejecuta la acción de expandir / contarer.
	 * 
	 * Parameters:
	 * 
	 * 	_oneTouchExpandable - Un Boolean.
	 * 
	 * Returns:
	 * 
	 * 	A Boolean.
 	 */	
	public function set oneTouchExpandable ( _oneTouchExpandable:Boolean )
	{
		__oneTouchExpandable = _oneTouchExpandable;		
		invalidate ();
	}
	
	[Inspectable(defaultValue="rightLeft", enumeration="rightLeft,bottomTop,leftRight,topBottom", category="Behaviour")]
	public function get expansionDirection ():String
	{
		return __expansionDirection;
	}
	/*
	 * Property: expansionDirection
	 * 
	 * Getter/setter.  Determina la dirección de expansion cuando el divider es expandido / contraido.
	 * 
	 * Parameters:
	 * 
	 * 	_expansionDirection - 	String que indica la dirección de expansion del divider.  
	 * 						Valore válidos son "rightLeft", "bottomTop", "leftRight", "topBottom"
	 * 
	 * Returns:
	 * 
	 * 	A String.
	 */	
	public function set expansionDirection ( _expansionDirection:String )
	{
		if ( _expansionDirection == "rightLeft" or _expansionDirection == "bottomTop" )
		{
			expansionDirectionIncr = 0;
		}
		else if ( _expansionDirection == "leftRight" or _expansionDirection == "topBottom" )
		{
			expansionDirectionIncr = 180;
		}
		else
		{
			error ( "new badExpansionDirectionException()" );
			return;
		}
		__expansionDirection = _expansionDirection;		
		resetToPreferredLocations ();
	}
	
	public function get dividerSize ():Number
	{
		return __dividerSize;
	}
	/*
	 * Property: dividerSize
	 * 
	 * Getter/setter. Getter/setter.  El tamaño en pixels del divider.
	 * 
	 * Parameters:
	 * 
	 * 	size - Un Number que indica el tamaño de divider.
	 * 
	 * Returns:
	 * 
	 * 	A Number.
	 */
	public function set dividerSize ( size:Number )
	{
		__dividerSize = Math.round(size);
		invalidate ();
	}

	public function get dividerLocation ():Number
	{
		return __dividerLocation;
	}
	/*
	 * Property: dividerLocation
	 * 
	 * Getter/setter. Getter/setter.  La posición del divider en %.
	 * (start code)
	 * // moves the divider to the 35% of the total space (left to right, top to bottom).
	 * mySplitPane.dividerLocation = 35;
	 * (end)
	 * 
	 * Parameters:
	 * 
	 * 	percent - Un Number que indica la posición del divider en % (de izq a der, de arriba a abajo)
	 * 
	 * Returns:
	 * 
	 * 	Un Number que indica la posición del divider en %.
	 */
	public function set dividerLocation ( percent:Number )
	{
		if ( percent <= __maximumDividerLocation or percent >= __minimumDividerLocation )
		{
			__dividerLocation = Math.round(percent);
		}
		else
		{
			error ( "new badDividerLocationException()" );
			return;
		}
		invalidate ();
	}
	
	public function get minimumDividerLocation ():Number
	{
		return __minimumDividerLocation;
	}
	/*
	 * Property: minimumDividerLocation
	 * 
	 * Getter/setter.  El valor mínimo en % donde el divider puede ser arrastrado.
	 * 
	 * Parameters:
	 * 
	 * 	percent - Un Number que indica la posición mínima del divider en % (de izq a der, de arriba a abajo).
	 * 
	 * Returns:
	 * 
	 * 	Un Number que indica la posición mínima del divider en %.
	 */	
	public function set minimumDividerLocation ( percent:Number )
	{
		__minimumDividerLocation = Math.round(percent);
		if ( dividerLocation < minimumDividerLocation )
		{
			dividerLocation = minimumDividerLocation;
		}
	}	
	
	public function get maximumDividerLocation ():Number
	{
		return __maximumDividerLocation;
	}
	/*
	 * Property: maximumDividerLocation
	 * 
	 * Getter/setter.  El valor máximo en % donde el divider puede ser arrastrado.
	 * 
	 * Parameters:
	 * 
	 * 	percent - Un Number que indica la posición máxima del divider en % (de izq a der, de arriba a abajo).
	 * 
	 * Returns:
	 * 
	 * 	Un Number que indica la posición máxima del divider en %.
	 */		
	public function set maximumDividerLocation ( percent:Number )
	{
		__maximumDividerLocation = Math.round(percent);
		if ( dividerLocation > maximumDividerLocation )
		{
			dividerLocation = maximumDividerLocation;
		}
	}	
	
	public function get dividerExpanded ():Boolean
	{
		return __dividerExpanded;
	}
	/*
	 * Property: dividerExpanded
	 * 
	 * Getter/setter. Asigna el estado de expansión a contraído (false) o expandido (true). 
	 * Cuando esta propiedad cambia , el evento *paneExpanded* es lanzado.
	 * 
	 * Parameters:
	 * 
	 * 	expanded - Un Boolean.
	 * 
	 * Returns:
	 * 
	 * 	Un Boolean.
	 */		
	public function set dividerExpanded ( expanded:Boolean )
	{
		__dividerExpanded = expanded;		
		if ( __dividerExpanded == false )
		{
			if ( expansionDirection == "rightLeft" or expansionDirection == "bottomTop" )
			{
				dividerLocation = 0;
			}
			else if ( expansionDirection == "leftRight" or expansionDirection == "topBottom" )
			{
				dividerLocation = 100;
			}			
		}
		else
		{
			dividerLocation = lastDividerLocation;
		}
		throwPaneExpandedEvent = true;
		invalidate ();
	}
	
	/*
	 * Property: lastDividerLocation
	 * 
	 * Getter. La posición previa a la actual en % del divider.
	 * 
	 * Returns:
	 * 
	 * 	A Number.
	 */	
	public function get lastDividerLocation ():Number
	{
		return __lastDividerLocation;
	}	
	public function set lastDividerLocation ( percent:Number )
	{
		__lastDividerLocation = percent;
	}

	/*
	 * Property: topComponent
	 * 
	 * Getter. Referencia al componente superior del SplitPane.
	 * 
	 * Returns:
	 * 
	 * 	Una instancia de ScrollPane o de SplitPane.
	 */
	public function get topComponent ():Object
	{
		return pane1;
	}
	/*
	 * Property: leftComponent
	 * 
	 * Getter. Referencia al componente izquierdo del SplitPane.
	 * 
	 * Returns:
	 * 
	 * 	Una instancia de ScrollPane o de SplitPane.
	 */	
	public function get leftComponent ():Object
	{
		return pane1;
	}
	/*
	 * Property: bottomComponent
	 * 
	 * Getter. Referencia al componente inferior del SplitPane.
	 * 
	 * Returns:
	 * 
	 * 	Una instancia de ScrollPane o de SplitPane.
	 */	
	public function get bottomComponent ():Object
	{
		return pane2;
	}
	/*
	 * Property: rightComponent
	 * 
	 * Getter. Referencia al componente derecho del SplitPane.
	 * 
	 * Returns:
	 * 
	 * 	Una instancia de ScrollPane o de SplitPane.
	 */	
	public function get rightComponent ():Object
	{
		return pane2;
	}

	private function setCursor (Void):Void
	{
		if ( orientation == SplitPane.VERTICAL_SPLIT )
		{
			cursorLinkage = "hResizeCursor"
		}
		else
		{
			cursorLinkage = "vResizeCursor"
		}
	}



	
	/*
	 * Functions 
	 */
	private function draw (Void):Void
	{
		oneTouchExpandable ? createDividers () : destroyObject ( "dividerControl" );
		// to avoid clipping
		pane1._visible = false;
		pane2._visible = false;
		// reset positions
		pane1._x = 0;
		pane1._y = 0;
		pane2._x = 0;
		pane2._y = 0;
		
		// draw the layout
		if ( orientation == SplitPane.HORIZONTAL_SPLIT )
		{
			var div1:Number 		= Math.round ( (__height * dividerLocation) / 100 );
			pane1.setSize 			( __width, div1 );
			dividerBar._x 			= 0;
			dividerBar._y 			= div1;			
			dividerBar._width 		= __width;
			dividerBar._height 		= dividerSize;
			dividerControl._y 		= dividerBar._y;
			dividerControl._x 		= (__width/2) - (dividerControl._width/2);			
			dividerControl._height 	= dividerSize;
			dividerControl.arrow._rotation = expansionDirectionIncr + ( dividerExpanded ? 90 : 270 );
			
			pane2._y 				= dividerBar._y + dividerBar._height;
			var div2:Number 		= Math.round ( __height - (div1+dividerBar._height) );
			pane2.setSize 			( __width, div2 );
	
			horizontalDividerEvents ();
		}
		else if ( orientation == SplitPane.VERTICAL_SPLIT )
		{
			var div1:Number 		= Math.round ( (__width * dividerLocation) / 100 );
			pane1.setSize 			( div1, __height );
			dividerBar._x 			= div1;
			dividerBar._y 			= 0;
			dividerBar._width 		= dividerSize;
			dividerBar._height 		= __height;
			dividerControl._y 		= (__height/2) - (dividerControl._height/2);
			dividerControl._x 		= dividerBar._x;
			dividerControl._width 	= dividerSize;
			dividerControl.arrow._rotation = expansionDirectionIncr + ( dividerExpanded ? 0 : 180 );
			
			pane2._x				= dividerBar._x + dividerBar._width;			
			var div2:Number 		= Math.round ( __width - (div1+dividerBar._width) );
			pane2.setSize 			( div2, __height );

			verticalDividerEvents 	();
		}
		if ( throwPaneExpandedEvent == true )
		{
			dispatchEvent ( 
							{
								type: 	"paneExpanded", 
								target: 	this								
							} 
						);
			throwPaneExpandedEvent = false;
		}
		// to avoid one frame late resizing
		pane1.redraw 			(true);
		pane2.redraw 			(true);
		
		if ( expansionDirection == "rightLeft" or expansionDirection == "bottomTop" )
		{
			pane1._visible 		= dividerExpanded;
			pane2._visible 		= true;
		}
		else if ( expansionDirection == "leftRight" or expansionDirection == "topBottom" )
		{
			pane1._visible 		= true;
			pane2._visible 		= dividerExpanded;
		}		
		setStyles 			();				
		dividerBar._visible 	= true;
		dividerControl._visible 	= true;
	}
	
	private function setStyles (Void):Void
	{
		if ( enabled )
		{
			new Color (dividerControl.control).setRGB		( getStyle ( "controlOutColor" ) );
			new Color (dividerControl.arrow).setRGB		( getStyle ( "arrowOutColor"   ) );
			new Color (dividerBar).setRGB 				( getStyle ( "dividerBarColor" ) );
		}
		else
		{
			new Color (dividerControl.control).setRGB		( getStyle ( "controlDisabledColor"    ) );
			new Color (dividerControl.arrow).setRGB		( getStyle ( "arrowDisabledColor"      ) );
			new Color (dividerBar).setRGB 				( getStyle ( "dividerBarDisabledColor" ) );
		}
	}
	
	/*
	 * overridden setEnabled() 
	 */
	private function setEnabled(enable:Boolean):Void
	{
		super.setEnabled ( enable );
		if ( enable == true )
		{
			disabler.removeMovieClip ();						
			pane1.enabled 			= true;
			pane2.enabled 			= true;
		}
		else
		{
			pane1.enabled 			= false;
			pane2.enabled 			= false;
			disabler 				= createObject ( "disabler", "disabler_mc", getNextHighestDepth() );
			disabler._width 		= __width;
			disabler._height 		= __height;
			disabler.onPress 		= function (){}
			disabler.useHandCursor 	= false;			
		}
		
	}
	
	private function size (Void):Void
	{
		super.size ();
		invalidate();
	}
	
	private function percentToPixels ( percent:Number, totalValue:Number ):Number
	{
		return (percent*totalValue) / 100;
	}
	
	private function pixelsToPercent ( pixels:Number, totalValue:Number ):Number
	{
		return (pixels*100) / totalValue;
	}
	
	/*
	 * Function: resetToPreferredLocations
	 * Resetea maximumDividerLocation, minimumDividerLocation, dividerLocation y asigna true a dividerExpanded.
	 */
	public function resetToPreferredLocations (Void):Void
	{
		if ( expansionDirection == "rightLeft" or expansionDirection == "bottomTop" )
		{
			maximumDividerLocation 	= 40;
			minimumDividerLocation 	= 15;
			dividerLocation 		= 25;			
		}
		else if ( expansionDirection == "leftRight" or expansionDirection == "topBottom" )
		{
			maximumDividerLocation 	= 85;
			minimumDividerLocation 	= 60;
			dividerLocation 		= 75;
		}		
		lastDividerLocation 	= dividerLocation;
		dividerExpanded 		= true;
		invalidate 			();
	}
	
	private function error ( err:String ):Void
	{
		trace ( err );
	}
	
	/*
	 * Function: nestLeft
	 * Anida una instancia de SplitPane en el leftPane del SplitPane en cuestión.
	 */
	public function nestLeft (Void):Void
	{
		nestPane1();
	}
	/*
	 * Function: nestTop
	 * Anida una instancia de SplitPane en el topPane del SplitPane en cuestión.
	 */
	public function nestTop (Void):Void
	{
		nestPane1();
	}
	
	/*
	 * Function: nestRight
	 * Anida una instancia de SplitPane en el rightPane del SplitPane en cuestión.
	 */
	public function nestRight (Void):Void
	{
		nestPane2();
	}
	/*
	 * Function: nestBottom
	 * Anida una instancia de SplitPane en el bottomPane del SplitPane en cuestión.
	 */
	public function nestBottom (Void):Void
	{
		nestPane2();
	}
	
	private function nestPane1 (Void):Void
	{
		destroyObject 		( "pane1" );
		createObject 		( "SplitPane", "pane1", 1, {_visible:false} );
	}
	
	private function nestPane2 (Void):Void
	{
		destroyObject 		( "pane2" );
		createObject 		( "SplitPane", "pane2", 2, {_visible:false} );
	}
	
	
	
	/*
	 * Events
	 */
	private function verticalDividerEvents (Void):Void
	{
		if ( dividerExpanded == true and enabled == true )
		{
			dividerBar.onRollOver 			= Delegate.create ( this, dividerBarOver );
			dividerBar.onRollOut 			= Delegate.create ( this, dividerBarOut );
			dividerBar.onPress 				= Delegate.create ( this, dividerBarPressVert );
			dividerBar.onRelease 			= Delegate.create ( this, dividerBarReleaseVert );
			dividerBar.onReleaseOutside		= Delegate.create ( this, dividerBarReleaseVert );
		}
		else
		{
			delete 	dividerBar.onRollOver;
			delete	dividerBar.onRollOut;
			delete	dividerBar.onPress;
			delete	dividerBar.onRelease; 
			delete	dividerBar.onReleaseOutside;
		}
		
		if ( oneTouchExpandable == true and enabled == true )
		{
			dividerControl.onRollOver 		= Delegate.create  ( this, dividerControlOver );
			dividerControl.onRollOut 		= Delegate.create  ( this, dividerControlOut );
			dividerControl.onRelease 		= Delegate.create  ( this, dividerControlRelease );
			dividerControl.onReleaseOutside 	= Delegate.create  ( this, dividerControlReleaseOutside );
		}
		else
		{
			delete 	dividerControl.onRollOver;
			delete	dividerControl.onRollOut; 
			delete	dividerControl.onRelease;
			delete	dividerControl.onReleaseOutside;
		}
		dividerBar.useHandCursor 		= false;
		dividerControl.useHandCursor 		= false;
	}
	
	private function horizontalDividerEvents (Void):Void
	{
		if ( dividerExpanded == true and enabled == true )
		{
			dividerBar.onRollOver 			= Delegate.create ( this, dividerBarOver );
			dividerBar.onRollOut 			= Delegate.create ( this, dividerBarOut );
			dividerBar.onPress 				= Delegate.create ( this, dividerBarPressHor );
			dividerBar.onRelease 			= Delegate.create ( this, dividerBarReleaseHor );
			dividerBar.onReleaseOutside		= Delegate.create ( this, dividerBarReleaseHor );
		}
		else
		{
			delete 	dividerBar.onRollOver;
			delete	dividerBar.onRollOut;
			delete	dividerBar.onPress;
			delete	dividerBar.onRelease; 
			delete	dividerBar.onReleaseOutside;
		}
		
		if ( oneTouchExpandable == true and enabled == true )
		{
			dividerControl.onRollOver 		= Delegate.create ( this, dividerControlOver );
			dividerControl.onRollOut 		= Delegate.create ( this, dividerControlOut );
			dividerControl.onRelease 		= Delegate.create ( this, dividerControlRelease );
			dividerControl.onReleaseOutside 	= Delegate.create ( this, dividerControlReleaseOutside );
		}
		else
		{
			delete 	dividerControl.onRollOver;
			delete	dividerControl.onRollOut; 
			delete	dividerControl.onRelease;
			delete	dividerControl.onReleaseOutside;
		}
		dividerBar.useHandCursor 		= false;
		dividerControl.useHandCursor 		= false;
	}	
	
	/////////////////////////////
	//                         //
	// Vertical and Horizontal //
	//                         //
	/////////////////////////////	
	private function dividerBarOver (Void):Void
	{
		cursorId = CursorManager.getCursorManager().setCursor( cursorLinkage );
	}
	private function dividerBarOut (Void):Void
	{
		CursorManager.getCursorManager().removeCursor( cursorId );
		cursorId = null;
	}
	
	private function dividerControlOver (Void):Void
	{
		var col_control:Color 	= new Color ( dividerControl.control );
		col_control.setRGB 		( getStyle ("controlOverColor") );		
		var col_arrow:Color		= new Color ( dividerControl.arrow );
		col_arrow.setRGB 		( getStyle ("arrowOverColor") );		
	}
	private function dividerControlOut (Void):Void
	{
		var col_control:Color	= new Color ( dividerControl.control );
		col_control.setRGB 		( getStyle ("controlOutColor") );		
		var col_arrow:Color 	= new Color ( dividerControl.arrow );
		col_arrow.setRGB 		( getStyle ("arrowOutColor") );
	}
	
	private function dividerControlReleaseOutside (Void):Void
	{
		var col_control:Color	= new Color ( dividerControl.control );
		col_control.setRGB 		( getStyle ("controlOutColor") );
		var col_arrow:Color 	= new Color ( dividerControl.arrow );
		col_arrow.setRGB 		( getStyle ("arrowOutColor") );
	}
	private function dividerControlRelease (Void):Void
	{		
		dividerExpanded = !dividerExpanded;
	}
	
	//////////////
	//          //
	// Vertical //
	//          //
	//////////////
	private function dividerBarPressVert (Void):Void
	{
		// workaround when rollOver, release and then press
		cursorId = CursorManager.getCursorManager().setCursor( cursorLinkage );
		var lev:Number 			= mx.managers.DepthManager.kCursor;
		dividerBar.duplicateMovieClip ( "fakeBar", lev-1, {_alpha:40, _visible:false} );
		fakeBar._x 				= dividerBar._x;		
		fakeBar.startDrag 			( 	false, 
									percentToPixels ( minimumDividerLocation, __width ), 
									0, 
									percentToPixels ( maximumDividerLocation, __width ), 
									0 
								);
		fakeBar._visible 			= true;
	}
	private function dividerBarReleaseVert (Void):Void
	{
		var newLocation:Number 	= Math.round(pixelsToPercent ( fakeBar._x, __width ));
		if ( newLocation != dividerLocation )
		{
			throwPaneExpandedEvent 	= true;			
			dividerLocation 		= newLocation;
			lastDividerLocation 	= dividerLocation;
		}
		fakeBar.stopDrag 		();
		destroyObject 			( "fakeBar" );
		CursorManager.getCursorManager().removeCursor( cursorId );		
	}
	
	////////////////
	//            //
	// Horizontal //
	//            //
	////////////////
	private function dividerBarPressHor (Void):Void
	{
		// workaround when rollOver, release and then press
		cursorId = CursorManager.getCursorManager().setCursor( cursorLinkage );
		var lev:Number 			= mx.managers.DepthManager.kCursor;
		dividerBar.duplicateMovieClip ( "fakeBar", lev-1, {_alpha:40, _visible:false} );
		fakeBar._y 				= dividerBar._y;
		fakeBar.startDrag 			( 	false, 
									0, 
									percentToPixels ( minimumDividerLocation, __height ), 
									0, 
									percentToPixels ( maximumDividerLocation, __height )
								);
		fakeBar._visible 			= true;
	}
	private function dividerBarReleaseHor (Void):Void
	{
		var newLocation:Number 	= Math.round(pixelsToPercent ( fakeBar._y, __height ));
		if ( newLocation != dividerLocation )
		{
			throwPaneExpandedEvent 	= true;			
			dividerLocation 		= newLocation;
			lastDividerLocation 	= dividerLocation;
		}
		fakeBar.stopDrag 		();
		destroyObject 			( "fakeBar" );
		CursorManager.getCursorManager().removeCursor( cursorId );		
	}	
}