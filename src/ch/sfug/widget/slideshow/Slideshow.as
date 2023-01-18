import ch.sfug.anim.tween.property.Fader;
import ch.sfug.data.LoopIterator;
import ch.sfug.events.AnimationEvent;
import ch.sfug.events.ErrorEvent;
import ch.sfug.events.Event;
import ch.sfug.events.ProgressEvent;
import ch.sfug.events.TimerEvent;
import ch.sfug.utils.Timer;
import ch.sfug.widget.BaseWidget;
import ch.sfug.widget.MediaResizer;
import ch.sfug.widget.slideshow.SlideshowImage;
/**
 * @author loop
 */
class ch.sfug.widget.slideshow.Slideshow extends BaseWidget {

	private var images:LoopIterator;
	private var img1:MediaResizer;
	private var img2:MediaResizer;
	private var fader:Fader;
	private var delay:Timer;
	private var run:Boolean;

	public function Slideshow( mc:MovieClip ) {
		super( mc );

		this.run = false;
		this.images = new LoopIterator();

		img1 = new MediaResizer( mc.createEmptyMovieClip( "img1", 1 ), MediaResizer.MASK );
		img1.loader.addEventListener( Event.INIT, onImageLoaded, this );
		img1.loader.addEventListener( ErrorEvent.ERROR, delegate, this );
		img1.loader.addEventListener( ProgressEvent.PROGRESS, delegate, this );

		img2 = new MediaResizer( mc.createEmptyMovieClip( "img2", 2 ), MediaResizer.MASK );
		img2.loader.addEventListener( Event.INIT, onImageLoaded, this );
		img2.loader.addEventListener( ErrorEvent.ERROR, delegate, this );
		img2.loader.addEventListener( ProgressEvent.PROGRESS, delegate, this );

		fader = new Fader( img1.target, 300 );
		fader.addEventListener( AnimationEvent.STOP, onTransitionOver, this );

		delay = new Timer( 200, 1 );
		delay.addEventListener( TimerEvent.TIMER_COMPLETE, onDelayOver, this );
	}

	/**
	 * sets the images for the slideshow
	 * @param imgs is a array of SlideshowImage instances
	 */
	public function setImages( imgs:Array ):Void {
		if( imgs.length > 0 ) {
			this.images.data = imgs;
		}
	}

	/**
	 * adjusts the time of the alpha transition duration
	 */
	public function setTransitionDuration( msec:Number ):Void {
		if( msec > 0 ) {
			fader.duration = msec;
		}
	}

	/**
	 * abstract getter/setter functions function
	 */
	public function set width( num:Number ):Void {
		super.width = num;
		img1.width = num;
		img2.width = num;
	}

	public function set height( num:Number ):Void {
		super.height = num;
		img1.height = num;
		img2.height = num;
	}

	/**
	 * starts the slideshow
	 */
	public function start(  ):Void {
		if( images.data.length > 0 ) {
			run = true;
			onDelayOver();
		} else {
			trace( "no images to start slideshow" );
		}
	}

	/**
	 * stops the slideshow
	 */
	public function stop(  ):Void {
		delay.stop();
		run = false;
	}

	/**
	 * returns the mediaresizer that is below the other
	 */
	private function getBelow(  ):MediaResizer {
		return ( img1.target.getDepth() > img2.target.getDepth() ) ? img2 : img1;
	}

	/**
	 * will be called when the image of one of the mediaresizers is loaded
	 */
	private function onImageLoaded():Void {
		fader.target = getBelow().target;
		fader.apply( 0 );
		img1.target.swapDepths( img2.target );
		fader.fadeTo( 100 );
	}

	/**
	 * will be called when the alpha fade is done and the delay should start
	 */
	private function onTransitionOver():Void {
		// just continue to load images when there are more than one image
		if( images.data.length > 1 && run ) {
			var current:SlideshowImage = SlideshowImage( images.current() );
			delay.delay = current.delay;
			delay.reset();
			delay.start();
		}
	}

	/**
	 * will be called when the image delay is over
	 */
	private function onDelayOver():Void {
		var next:SlideshowImage = SlideshowImage( images.next() );
		getBelow().loader.load( next.url );
	}

	/**
	 * delegates the events
	 */
	private function delegate( e:Event ):Void {
		dispatchEvent( e );
	}

}