import ascb.containers.Window;

class ascb.containers.Panel extends Window {

  function Panel(mParent:MovieClip) {
    super(mParent);
    _bDraggable = false;
    _bResizable = false;
    shadow = false;
    closeButton = false;
  }

}