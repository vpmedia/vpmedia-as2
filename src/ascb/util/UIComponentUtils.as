class ascb.util.UIComponentUtils {

  private static var _oDataProviders:Object;

  public static function correlate(oA:Object, oB:Object, aDataProviders:Array):Void {
    if(_oDataProviders == undefined) {
      _oDataProviders = new Object();
      _oDataProviders.close = function(oEvent:Object):Void {
        this[oEvent.target._name].menu.dataProvider = this[oEvent.target._name].dataproviders[oEvent.target.selectedIndex];
      };
      _oDataProviders.change = function(oEvent:Object):Void {
        this.close(oEvent);
      };
    }
    _oDataProviders[oA._name] = {menu: oB, dataproviders: aDataProviders};
    if(oA.className == "ComboBox") {
      oA.addEventListener("close", _oDataProviders);
    }
    else {
      oA.addEventListener("change", _oDataProviders);
    }
  }

  public static function fitItemsWidth(oInstance:Object):Void {
    var nWidth:Number = 0;
    var nItemWidth:Number;
    var clList:mx.controls.List;
    if(oInstance.className == "ComboBox") {
      oInstance.open();
      clList = oInstance.dropdown;
    }
    else {
      clList = mx.controls.List(oInstance);
    }
    for(var i:Number = 0; i < clList.length; i++) {
      nItemWidth = clList._getTextFormat().getTextExtent(oInstance.getItemAt(i).label).width;
      if(nItemWidth > nWidth) {
        nWidth = nItemWidth;
      }
    }
    if(oInstance.className == "ComboBox") {
      oInstance.close();
    }
    oInstance.setSize(nWidth + 25, oInstance.height);
  }

  public static function addRadioButtonGroup(mParent:MovieClip, oDataProvider:Object, sGroupName:String, nX:Number, nY:Number, nSpacing:Number):Array {
    var nDepth:Number;
    var crbInstance:mx.controls.RadioButton;
    var aInstances:Array = new Array();
    if(nX == undefined) {
      nX = 0;
    }
    if(nY == undefined) {
      nY = 0;
    }
    if(nSpacing == undefined) {
      nSpacing = 5;
    }
    var nItemCount:Number = (oDataProvider instanceof Array) ? oDataProvider.length : oDataProvider.getLength();
    var oDataProviderElement:Object;
    for(var i:Number = 0; i < nItemCount; i++) {
      nDepth = mParent.getNextHighestDepth();
      oDataProviderElement = (oDataProvider instanceof Array) ? oDataProvider[i] : oDataProvider.getItemAt(i);
      crbInstance = mParent.createClassObject(mx.controls.RadioButton, "____RadioButton" + nDepth, nDepth, oDataProviderElement);
      if(sGroupName != undefined) {
        crbInstance.groupName = sGroupName;
      }
      crbInstance.move(nX, nY + (i * (crbInstance.height + nSpacing)));
      aInstances.push(crbInstance);
    }
    return aInstances;
  }

  public static function addCheckBoxes(mParent:MovieClip, oDataProvider:Object, nX:Number, nY:Number, nSpacing:Number):Array {
    var nDepth:Number;
    var cchInstance:mx.controls.CheckBox;
    var aInstances:Array = new Array();
    if(nX == undefined) {
      nX = 0;
    }
    if(nY == undefined) {
      nY = 0;
    }
    if(nSpacing == undefined) {
      nSpacing = 5;
    }
    var nItemCount:Number = (oDataProvider instanceof Array) ? oDataProvider.length : oDataProvider.getLength();
    var oDataProviderElement:Object;
    for(var i:Number = 0; i < nItemCount; i++) {
      nDepth = mParent.getNextHighestDepth();
      oDataProviderElement = (oDataProvider instanceof Array) ? oDataProvider[i] : oDataProvider.getItemAt(i);
      cchInstance = mParent.createClassObject(mx.controls.CheckBox, "____CheckBox" + nDepth, nDepth);
      cchInstance.label = (typeof oDataProviderElement == "string") ? oDataProviderElement : oDataProviderElement.label;
      cchInstance.move(nX, nY + (i * (cchInstance.height + nSpacing)));
      aInstances.push(cchInstance);
    }
    return aInstances;
  }

  public static function applyTreeIcons(ctrTree:mx.controls.Tree, xnNode:XMLNode):Void {
    if(xnNode == undefined) {
      xnNode = XMLNode(ctrTree.dataProvider);
    }
    for(var i:Number = 0; i < xnNode.childNodes.length; i++) {
      if(xnNode.childNodes[i].childNodes.length > 0) {
        applyTreeIcons(ctrTree, xnNode.childNodes[i]);
      }
      ctrTree.setIcon(xnNode.childNodes[i], xnNode.childNodes[i].attributes.icon1, xnNode.childNodes[i].attributes.icon2);
    }
  }

  public static function setSelectedItem(oList:Object, oData:Object):Void {
    for(var i:Number = 0; i < oList.length; i++) {
      if(oList.getItemAt(i) == oData || oList.getItemAt(i).data == oData) {
        oList.selectedIndex = i;
        break;
      }
    }
  }

  public static function setSelectedItems(oList:Object, aData:Array):Void {
    var aIndices:Array = new Array();
    for(var i:Number = 0; i < oList.length; i++) {
      if(ascb.util.ArrayUtils.findMatchIndex(aData, oList.getItemAt(i)) != -1 || ascb.util.ArrayUtils.findMatchIndex(aData, oList.getItemAt(i).data) != -1) {
        aIndices.push(i);
      }
    }
    oList.selectedIndices = aIndices;
  }

}