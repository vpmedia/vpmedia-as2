class ascb.data.Transfer {

  public static function sendURLEncoded(aData:Array, sURL:String, sMethod:String):Void {
    var lvData:LoadVars = new LoadVars();
    for(var i:Number = 0; i < aData.length; i++) {
      lvData[aData[i].name] = aData[i].data;
    }
    lvData.sendAndLoad(sURL, lvData, (sURL == undefined) ? "POST" : sURL);
  }

  public static function sendXML(aData:Array, sURL:String):Void {
    var sXML:String = "<data>";
    for(var i:Number = 0; i < aData.length; i++) {
      sXML += "<item name='" + aData[i].name + "' data='" + aData[i].data + "' />";
    }
    sXML += "</data>";
    var xmlData:XML = new XML(sXML);
xmlData.onLoad = function():Void {
  trace("asdf");
};
    xmlData.sendAndLoad(sURL, xmlData);
  }

}