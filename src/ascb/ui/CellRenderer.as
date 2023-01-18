import mx.controls.List;

class ascb.ui.CellRenderer extends MovieClip {

  private var listOwner:List;
  private var owner:MovieClip;
  private var createClassObject:Function;
  private var getCellIndex:Function;
  private var getDataLabel:Function;

  function CellRenderer() {
  }

  public function getPreferredWidth():Number {
    return owner.width;
  }

  public function getPreferredHeight():Number {
    return owner.height;
  }

}