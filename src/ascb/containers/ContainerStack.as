import ascb.containers.Container;

/**
A ContainerStack, as the name suggests, is a stack of Container
instances. One is visible at a time.
*/

class ascb.containers.ContainerStack {

  private var _aContainers:Array;
  private var _aLabels:Array;
  private var _nSelectedIndex:Number;
  private var _nX:Number;
  private var _nY:Number;
  public var addEventListener:Function;
  public var removeEventListener:Function;
  private var dispatchEvent:Function;

  public function set _x(nX:Number):Void {
    _nX = nX;
    for(var i:Number = 0; i < _aContainers.length; i++) {
      _aContainers[i]._x = nX;
    }
  }

  public function get _x():Number {
    return _nX;
  }

  public function set _y(nY:Number):Void {
    _nY = nY;
    for(var i:Number = 0; i < _aContainers.length; i++) {
      _aContainers[i]._y = nY;
    }
  }

  public function get _y():Number {
    return _nY;
  }

  public function get length():Number {
    return _aContainers.length;
  }

  public function set selectedIndex(nIndex:Number):Void {
    if(nIndex < 0 || nIndex > _aContainers.length - 1) {
      return;
    }
    _aContainers[_nSelectedIndex]._visible = false;
    _aContainers[nIndex]._visible = true;
    _nSelectedIndex = nIndex;
    dispatchEvent({type: "change", target: this});
  }

  public function get selectedIndex():Number {
    return _nSelectedIndex;
  }

  public function get labels():Array {
    return _aLabels.concat();
  }

  function ContainerStack() {
    init();
  }

  private function init():Void {
    mx.events.EventDispatcher.initialize(this);
    _nX = 0;
    _nY = 0;
    _aContainers = new Array();
    _aLabels = new Array();
    _nSelectedIndex = 0;
  }

  public function addContainer(oContainer:Object, sLabel:String):Void {
    _aContainers.push(oContainer);
    _aLabels.push(sLabel);
    if(_aContainers.length > 1) {
      oContainer._visible = false;
    }
    oContainer.containerIndex = _aContainers.length - 1;
  }

  public function removeContainerAt(nIndex:Number):Void {
    _aContainers[nIndex].remove();
    _aContainers.splice(nIndex, 1);
    _aLabels.splice(nIndex, 1);
    for(var i:Number = 0; i < _aContainers.length; i++) {
      _aContainers.containerIndex = i;
    }
  }

  public function getContainerAt(nIndex:Number):Object {
    return _aContainers[nIndex];
  }

}