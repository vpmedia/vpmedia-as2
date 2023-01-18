/**
 * 
 * @author Wersling
 * @version 1.0, 2006-6-3
 */
class net.manaca.ui.controls.listClasses.DataSelector {
	private var className : String = "net.manaca.ui.controls.listClasses.DataSelector";
	static var mixins: DataSelector = new DataSelector();
	static var mixinProps : Array = [ "setDataProvider", "getDataProvider",  "addItem", "addItemAt", "removeAll", "removeItemAt",
							 "replaceItemAt", "sortItemsBy", "sortItems", "getLength", "getItemAt", "modelChanged",
							 "calcPreferredWidthFromData", "calcPreferredHeightFromData", "getValue", "getSelectedIndex",
							 "getSelectedItem", "getSelectedIndices", "getSelectedItems", "selectItem", "isSelected",
							 "clearSelected", "setSelectedIndex", "setSelectedIndices"];

	private var __dataProvider : Object;
	static function Initialize(obj) : Boolean{
		var m = mixinProps;
		var l = m.length;

		obj = obj.__proto__;
		for (var i=0; i<l; i++) {
			obj[m[i]] = mixins[m[i]];
		}

		// add getter/setter properties
		mixins.createProp(obj, "dataProvider", true);
		mixins.createProp(obj, "length", false);
		mixins.createProp(obj, "value", false);
		mixins.createProp(obj, "selectedIndex", true);
		mixins.createProp(obj, "selectedIndices", true);
		mixins.createProp(obj, "selectedItems", false);
		mixins.createProp(obj, "selectedItem", true);
		return true;
	}
	
	function createProp(obj : Object, propName:String, setter:Boolean) : Void
	{
		var p = propName.charAt(0).toUpperCase() + propName.substr(1);
		var s = null;
		var g = function(Void)
		{
			return this["get" + p]();
		};
		if (setter) {
			s = function(val)
			{
				this["set" + p](val);
			};
		}
		obj.addProperty(propName, g, s);

	}
	
	function setDataProvider(dP : Object) : Void{
		__dataProvider = dP;
		Tracer.debug('__dataProvider: ' + __dataProvider.size());
	}
	function addItem(o) : Void{
		var dp = __dataProvider;
		trace(dp);
		dp.addItem(o);
	}
}