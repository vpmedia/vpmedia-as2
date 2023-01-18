/**
 * Hue Prototype Tween Example
 *  
 * Copyright (c) 2006, David Knape
 * Released under the open-source MIT license. 
 * See LICENSE.txt for full license terms.
 * 
 * Compiles in FlashDevelop. No FLA necessary. 
 * @mtasc -version 8 -swf com/bumpslide/example/ftween/HueTweening.swf -header 500:400:31:eeeedd -main -trace com.bumpslide.util.Debug.info
 * @author David Knape 
 */
 
import com.bumpslide.ui.ResizableImage;
import com.bumpslide.ui.Slider;
import com.bumpslide.util.*;

class com.bumpslide.example.ftween.HueTweening extends com.bumpslide.core.MtascApplet
{
	var holder_mc:MovieClip;
	var image_mc:ResizableImage;
	var slider_mc:Slider;	
	var slider2_mc:Slider;
	
	//var imageUrl : String = 'orange_chairs.jpg';	// for running on the web
	//var imageUrl : String = 'com/bumpslide/example/ftween/orange_chairs.jpg'; // when compiling using "Quick MTASC Compile"
	
	function get imageUrl () : String {
		return _url.substring(0,4)=='http' ? 'orange_chairs.jpg' : 'com/bumpslide/example/ftween/orange_chairs.jpg';
	}
	
	// init
	function init() {
		
		// Init Hue/Saturation MovieClip.prototype extensions
		HueSatProto.init();				
		
		// show framerate monitor
		FramerateMonitor.display(this);
		
		stage.eventMode = StageProxy.PASS_THRU;
		
		createChildren();		
		
		onEnterFrame = updateLabels;
	}
	

	
	function createChildren() {
		
		// fill background with color
		createEmptyMovieClip( 'holder_mc', 1);
				
		// create image holder
		image_mc = ResizableImage.create( 'image_mc', holder_mc );	
		image_mc.addEventListener( ResizableImage.EVENT_IMAGE_LOADED, this );
		image_mc.loadImage( imageUrl );
		
		// create slider for hue
		Slider.create( 'slider_mc', this );
		slider_mc.max = 360;
		slider_mc._visible = false;
		slider_mc.addEventListener( Slider.EVENT_VALUE_CHANGE, Delegate.create( this, onSliderChanged) );
		
		// create slider for saturation
		Slider.create( 'slider2_mc', this );
		slider2_mc.max = 200;
		slider2_mc.value = 100;
		slider2_mc._visible = false;
		slider2_mc.addEventListener( Slider.EVENT_VALUE_CHANGE, Delegate.create( this, onSlider2Changed) );	
	
	}
	
	// once image is loaded, trigger stage update (onStageResize)
	function onImageLoaded() {
		Debug.trace('image loaded');
		onStageResize();
	}
	
	// Hue Slider
	function onSliderChanged(e:Object) {
		FTween.ease(holder_mc, '_hue', Math.round( slider_mc.value ), .3);
	}
	
	// Saturation Slider
	function onSlider2Changed(e:Object) {
		FTween.ease(holder_mc, '_saturation', Math.round( slider2_mc.value ), .3);
	}
		
	// redraw boxes when stage size changes
	function onStageResize() {			
		
		// fill background color
		Draw.box( holder_mc, stage.width, stage.height, 0xCC3333, 100);
		
		if(!image_mc.imageLoaded) return;		
		image_mc.setSize( stage.width*.6, stage.height*.6 );		
		Align.center( image_mc );
		Align.middle( image_mc, stage.height - 70 );
		
		
		slider_mc._visible = true;
		slider_mc.setSize( image_mc._width-100, 28 );
		slider_mc._x = image_mc._x;
		slider_mc._y = image_mc._y + image_mc.height + 10;
		
		slider2_mc._visible = true;
		slider2_mc.setSize( image_mc._width-100, 28 );
		slider2_mc._x = image_mc._x;
		slider2_mc._y = image_mc._y + image_mc.height + 40;
		
		updateLabels();
	}
	
	function updateLabels() {
		
		if(!image_mc.imageLoaded) return;
		
		var x = image_mc._x + slider_mc._width + 10;
		createLabel( 1, "Hue: "+Math.round(holder_mc._hue), x, slider_mc._y + 6 );
		createLabel( 2, "Saturation: "+Math.round( holder_mc._saturation ), x, slider2_mc._y + 6 );
	}
	
	function createLabel( n, labelText, x, y ) {		
		createTextField( 'text'+n, 10+n, x, y, 200, 20 );
		var txt:TextField = this['text'+n];
		txt.setNewTextFormat( new TextFormat( "Verdana", 10, 0xffffff, true ) );	
		txt.text = labelText;
	}
	
	function showStatus() {
		clearMessage();
		message('Hue: '+holder_mc._hue+ ', Saturation: '+holder_mc._saturation );
	}
	
	/*
	// click
	function onMouseDown() {
		onEnterFrame = showStatus;
		//holder_mc._hue+=10;
		holder_mc._hue %= 360;
		FTween.ease(holder_mc, '_hue', holder_mc._hue+30, .1, .1);	
	}*/
	
	
	
	
	
	
	static function main(root_mc:MovieClip) : Void {			
		ClassUtil.applyClassToObj( HueTweening, root_mc );		
	}
}

