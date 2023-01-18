import ascb.managers.DepthManager;

/**
The Container class isn't generally instantiated directly.
Instead, it is the base class for any container (Box, Form, etc.).
*/

class ascb.containers.Container {

  private var _aElements:Array;
  private var _oElements:Object;
  private var _nX:Number;
  private var _nY:Number;
  private var _nSpacing:Number;
  private var _nWidth:Number;
  private var _nHeight:Number;
  private var _mParent:MovieClip;
  private var _mBackground:MovieClip;
  private var _sName:String;
  private var _bVisible:Boolean;
  private var _nContainerIndex:Number;
  public var addEventListener:Function;
  public var removeEventListener:Function;
  private var dispatchEvent:Function;

  public function set containerIndex(nIndex:Number):Void {
    _nContainerIndex = nIndex;
  }

  public function get containerIndex():Number {
    return _nContainerIndex;
  }

  public function set _visible(bVisible:Boolean):Void {
    _bVisible = bVisible;
    setElementsProperty("_visible", bVisible, true);
  }

  public function get _visible():Boolean {
    return (_bVisible == true);
  }

  public function set _alpha(nAlpha:Number):Void {
    setElementsProperty("_alpha", nAlpha);
  }

  /**
   * The number of elements in the container.
   */
  public function get length():Number {
    return _aElements.length;
  }

  /**
   * This property can be used by the container when it is
   * an element of another container. The property is set in the
   * constructor.
   */
  public function get _name():String {
    return _sName;  
  }

  /**
   *  The movie clip into which any elements are created by the
   *  container. A container can "contain" elements that are
   *  technically in any movie clip. The target property is just
   *  so the container knows where to dynamically create elements.
   *  The default is _root.
   */
  public function set parent(mParent:MovieClip):Void {
    _mParent = mParent;
  }

  public function get parent():MovieClip {
    return _mParent;
  }

  /**
   *  @deprecated
  */
  public function set target(mParent:MovieClip):Void {
    _mParent = mParent;
  }
  

  public function set _x(nX:Number):Void {
    _nX = nX;
    arrange();
  }

  public function get _x():Number {
    return _nX;
  }

  public function set _y(nY:Number):Void {
    _nY = nY;
    arrange();
  }

  public function get _y():Number {
    return _nY;
  }

  public function get _width():Number {
    return _nWidth;
  }

  public function get _height():Number {
    return _nHeight;
  }

  /**
   *  The number of pixels between elements.
   */
  public function set spacing(nSpacing:Number):Void {
    _nSpacing = nSpacing;
    arrange();
  }

  public function get spacing():Number {
    return _nSpacing;
  }

  public function Container(oParameters:Object) {
    init();
    if(oParameters instanceof MovieClip) {
      _mParent = MovieClip(oParameters);
    }
    else {
      if(oParameters.name != undefined) {
        _sName = oParameters.name;
      }
      if(oParameters.parent != undefined) {
        _mParent = oParameters.parent;
      }
      if(oParameters.elements != undefined) {
        for(var i:Number = 0; i < oParameters.elements.length; i++) {
          addElement(oParameters.elements[i], null, true);
        }
        arrange();
      }
    }
  }

  private function init():Void {
    mx.events.EventDispatcher.initialize(this);
    _aElements = new Array();
    _oElements = new Object();
    _nX = 0;
    _nY = 0;
    _nSpacing = 5;
    _nWidth = 0;
    _nHeight = 0;
    _mParent = _root;
  }

  /**
   *  Add an element to the container.
   *  @param  element   Can be an existing object reference, a
   *                    symbol linkage ID, or a class reference.
   *  @param  init      An initialization object.
   *  @param  defer     Whether to defer calling the arrange() method.
   */
  public function addElement(oElement:Object, oInit:Object, bDefer:Boolean):Object {
    var nDepth:Number = DepthManager.getInstance().getNextDepth(_mParent);
    var oElementInstance:Object;
    if(oElement instanceof Function) {
      oElementInstance = _mParent.createClassObject(oElement, "__ContainerElement" + nDepth, nDepth, oInit);
    }
    else if(typeof oElement == "string") {
      oElementInstance = _mParent.attachMovie(String(oElement), "__ContainerElement" + nDepth, nDepth, oInit);
    }
    else {
      oElementInstance = oElement;
    }
    _aElements.push(oElementInstance);
    _oElements[oElementInstance._name] = oElementInstance;
    if(!bDefer) {
      arrange();
    }
    return oElementInstance;
  }

  /**
   *  Remove an element by reference.
   */
  public function removeElement(oElement:Object):Void {
    delete _oElements[oElement._name];
    for(var i:Number = 0; i < _aElements.length; i++) {
      if(_aElements[i] == oElement) {
        _aElements.splice(i, 1);
        break;
      }
    }
    if(oElement instanceof MovieClip) {
      oElement.removeMovieClip();
    }
    arrange();
  }

  /**
   *  Remove an element by index.
   */
  public function removeElementAt(nIndex:Number):Void {
    delete _oElements[_aElements[nIndex]._name];
    if(_aElements[nIndex] instanceof MovieClip) {
      _aElements[nIndex].removeMovieClip();
    }
    _aElements.splice(nIndex, 1);
    arrange();
  }

  /**
   *  Get an element at a particular index.
   */
  public function getElementAt(nIndex:Number):Object {
    return _aElements[nIndex];
  }

  /**
   *  Set a property of every element in a container. In the case of
   *  analagous properties in MovieClip/Button/TextField and UIObject
   *  elements, use the MovieClip property name. The method will
   *  determine the UIObject equivalent. For example, if you specify
   *  _x, the method will set the _x property of any MovieClip/Button/
   *  TextField as well as the x property of any UIObject instance.
   *  @param  property   The name of the property as a string.
   *  @param  value      The value to assign the property.
   *  @param  recurse    (optional) Either true or false. If true,
   *                     Then the properties of subelements are also
   *                     affected.
   */
  public function setElementsProperty(sProperty:String, oValue:Object, bRecurse:Boolean):Void {
    for(var i:Number = 0; i < _aElements.length; i++) {
      if(_aElements[i] instanceof mx.core.UIObject && ascb.util.ArrayUtils.findMatchIndex(["_visible", "_x", "_y", "_width", "_height"], sProperty) != -1) {
        var sUIObjectProperty:String = sProperty;
        var aCharacters:Array = sUIObjectProperty.split("");
        aCharacters.shift();
        sUIObjectProperty = aCharacters.join("");
        _aElements[i][sUIObjectProperty] = oValue;
      }
      else {
        _aElements[i][sProperty] = oValue;
      }
      if(bRecurse && _aElements[i] instanceof ascb.containers.Container) {
        _aElements[i].setElementsProperty(sProperty, oValue, bRecurse);
      }
    }
  }

  public function remove():Void {
    for(var i:Number = 0; i < _aElements.length; i++) {
      if(_aElements[i] instanceof ascb.containers.Container) {
        _aElements[i].remove();
      }
      else {
        _aElements[i].removeMovieClip();
        if(_aElements[i] != undefined) {
          _mParent.createEmptyMovieClip("____Deleted", _aElements[i].getDepth());//(_mParent.____Deleted.getDepth() != undefined) ? _mParent.____Deleted.getDepth() : _mParent.getNextHighestDepth());
          //_mParent
        }
      }
    }
  }

  /**
   *  Must be implemented in subclasses.
   */
  public function arrange():Void {

  }

}