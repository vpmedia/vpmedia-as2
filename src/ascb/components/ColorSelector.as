import ascb.drawing.Pen;
import ascb.managers.DepthManager;

class ascb.components.ColorSelector extends MovieClip {

  private var _nSelectedColor:Number;
  private var _mSelector:MovieClip;
  private var _mBackground:MovieClip;
  private var _mSelectedSwatch:MovieClip;
  private var _tSelectedCode:TextField;
  private var _mSwatches:MovieClip;
  private var _mBoundingBox:MovieClip;

  public var addEventListener:Function;
  public var removeEventListener:Function;
  private var dispatchEvent:Function;

  [Inspectable(type='Color', defaultValue='#FFFFFF')]
  public function get selectedColor():Number {
    return _nSelectedColor;
  }

  public function set selectedColor(nSelectedColor):Number {
    _nSelectedColor = nSelectedColor;
    drawSelectedSwatch();
  }

  public function ColorSelector() {
     init();
  }

  private function init():Void {
    _mBoundingBox._width = 0;
    _mBoundingBox._height = 0;
    _mBoundingBox._visible = false;
    mx.events.EventDispatcher.initialize(this);
    createEmptyMovieClip("_mSelector", 1);
    _mSelector.createEmptyMovieClip("mBackground", 1);
    _mSelector.createEmptyMovieClip("mSwatch", 2);
    _mSelector.createEmptyMovieClip("mArrow", 3);
    _mSelector.onPress = ascb.util.Proxy.create(this, toggle);
    createEmptyMovieClip("_mBackground", 2);
    createEmptyMovieClip("_mSelectedSwatch", 3);
    createTextField("_tSelectedCode", 4, 35, 25, 100, 20);
    _tSelectedCode.background = true;
    createEmptyMovieClip("_mSwatches", 5);
    _mBackground._y = 20;
    _mSelectedSwatch._x = 5;
    _mSelectedSwatch._y = 25;
    _mSwatches._x = 5;
    _mSwatches._y = 50;
    toggle();
    draw();
  }

  private function toggle():Void {
    _mBackground._visible = !_mBackground._visible;
    _mSelectedSwatch._visible = !_mSelectedSwatch._visible;
    _tSelectedCode._visible = !_tSelectedCode._visible;
    _mSwatches._visible = !_mSwatches._visible;
  }

  private function draw():Void {

    var pSelector:Pen = new Pen(_mSelector.mBackground);
    pSelector.lineStyle(0, 0, 0);
    pSelector.beginFill(0xACA899);
    pSelector.drawRectangle(25, 20, 0, 0, 0, 0, "upperleft");
    pSelector.endFill();
    pSelector.beginFill(0xF2EFE6);
    pSelector.drawRectangle(24, 19, 0, 0, 0, 0, "upperleft");
    pSelector.endFill();
    pSelector.beginFill(0xECE9D8);
    pSelector.drawRectangle(23, 18, 0, 0, 1, 1, "upperleft");
    pSelector.endFill();
    pSelector.beginFill(_nSelectedColor);
    drawSelectorSwatch();
    pSelector.target = _mSelector.mArrow;
    pSelector.lineStyle(0, 0, 0);
    pSelector.beginFill(0xF2EFE6);
    pSelector.drawRectangle(8, 8, 0, 0, 16, 11, "upperleft");
    pSelector.endFill();
    pSelector.beginFill(0x000000);
    pSelector.drawTriangle(5, 5, 60, 0, 17, 12, "upperleft");
    pSelector.endFill();
     
    var pBackground:Pen = new Pen(_mBackground);
    pBackground.lineStyle(0, 0, 0);
    pBackground.beginFill(0xACA899);
    pBackground.drawRectangle(190, 155, 0, 0, 0, 0, "upperleft");
    pBackground.endFill();
    pBackground.beginFill(0xF2EFE6);
    pBackground.drawRectangle(189, 154, 0, 0, 0, 0, "upperleft");
    pBackground.endFill();
    pBackground.beginFill(0xECE9D8);
    pBackground.drawRectangle(188, 153, 0, 0, 1, 1, "upperleft");
    pBackground.endFill();

    var mSwatch:MovieClip;
    var nRed:Number;
    var nGreen:Number;
    var nBlue:Number;
    var nRGB:Number;

    // Create the swatches. There are 216 swatches total--six blocks of six-by-six
    // swatches. Create three nested for loops to accomplish 
    for (var nRedModifier:Number = 0; nRedModifier < 6; nRedModifier ++) {
      for (var nBlueModifier:Number = 0; nBlueModifier < 6; nBlueModifier++) {
        for (var nGreenModifier:Number = 0; nGreenModifier < 6; nGreenModifier++) {
     
          // The red, green, and blue values of each swatch follow a pattern that 
          // you can see for yourself if you experiment with the color selector in
          // the Flash authoring environment. This code follows the same pattern. 
          nRed = 0x33 * nRedModifier;
          nGreen = 0x33 * nGreenModifier; 
          nBlue = 0x33 * nBlueModifier;
          nRGB = (nRed << 16) | (nGreen << 8) | nBlue;
     
          // Create each swatch with the createSwatch(  ) 
          // method (see the following code).
          mSwatch = createSwatch(nRGB);
     
          // Move each swatch to its correct position.
          mSwatch._y = 10 * nBlueModifier;
          mSwatch._x = 10 * nGreenModifier + (nRedModifier * 60);
          if (nRedModifier >= 3) {
            mSwatch._y += 60;
            mSwatch._x -= 180;
          }
        }
      }
    }
  }

  private function drawSelectorSwatch():Void {
    var pSelector:Pen = new Pen(_mSelector.mSwatch);
    pSelector.clear();
    pSelector.lineStyle(0, 0, 0);
    pSelector.beginFill(_nSelectedColor);
    pSelector.drawRectangle(21, 16, 0, 0, 2, 2, "upperleft");
    pSelector.endFill();
  }
     
  private function createSwatch(nRGB:Number):MovieClip {
     
    // Create the movie clips for the swatches. Each swatch name and depth must be
    // unique. Accomplish this by using the value of the num property, which is
    // incremented each time a new swatch is created.
    var nDepth:Number = DepthManager.getInstance().getNextDepth(_mSwatches);
    var mSwatch:MovieClip = _mSwatches.createEmptyMovieClip(
                    "mSwatch" + nDepth, nDepth);
    drawSwatch(mSwatch, nRGB);
    // When the swatch is clicked, set the selectColor property of the color
    // selector component instance to the value of the swatch's rgb property. The
    // selectColor property is listened to, so the onSelectedColorChange(  ) method
    // of any listener objects is automatically invoked.
    mSwatch.onRollOver = ascb.util.Proxy.create(this, rollover, mSwatch, nRGB);
    mSwatch.onRollOut = ascb.util.Proxy.create(this, rollout, mSwatch, nRGB);
    mSwatch.onRelease = ascb.util.Proxy.create(this, select, nRGB);
    // Return a reference to the mSwatch clip.
    return mSwatch;
  }

  private function select(nRGB):Void {
    _nSelectedColor = nRGB;
    drawSelectorSwatch();
    toggle();
    dispatchEvent({type: "change", target: this});
  }

  private function rollover(mSwatch:MovieClip, nRGB:Number):Void {
    mSwatch.swapDepths(DepthManager.getInstance().getHighestDepthInUse(_mSwatches));
    var sCode:String = nRGB.toString(16).toUpperCase();
    for(var i:Number = sCode.length; i < 6; i++) {
      sCode = "0" + sCode;
    }
    _tSelectedCode.text = "#" + sCode;
    var tfFormatter:TextFormat = new TextFormat();
    tfFormatter.font = "_sans";
    tfFormatter.size = 10;
    _tSelectedCode.setTextFormat(tfFormatter);
    drawSwatch(mSwatch, nRGB, true);
    drawSelectedSwatch(nRGB);
  }

  private function rollout(mSwatch:MovieClip, nRGB:Number):Void {
    drawSwatch(mSwatch, nRGB, false);
  }

  private function drawSelectedSwatch(nRGB:Number):Void {
    var pSwatch:Pen = new Pen(_mSelectedSwatch);
    pSwatch.lineStyle(0, 0, 0);
    pSwatch.beginFill(nRGB);
    pSwatch.drawRectangle(25, 20, 0, 0, 0, 0, "upperleft");
    pSwatch.endFill();
  }

  private function drawSwatch(mSwatch:MovieClip, nRGB:Number, bRollOver:Boolean):Void {
    var pSwatch:Pen = new Pen(mSwatch);
    pSwatch.clear();
    pSwatch.lineStyle(0, (bRollOver) ? 0xFFFFFF : 0x000000, 100);
    pSwatch.beginFill(nRGB, 100);
    pSwatch.drawRectangle(10, 10, 0, 0, 0, 0, "upperleft");
    pSwatch.endFill();
  }


}