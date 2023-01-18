import net.manaca.ui.controls.data.IDataFormatter;
import net.manaca.util.ObjectUtil;
import net.manaca.ui.controls.listClasses.ListDataProvider;
import net.manaca.data.components.DataTable;
import net.manaca.data.components.DataSet;
import net.manaca.util.ClassUtil;
import net.manaca.data.Collection;

/**
 * 
 * @author Wersling
 * @version 1.0, 2006-5-22
 */
class net.manaca.ui.controls.listClasses.ListDataFormatter implements IDataFormatter {
	private var className : String = "net.manaca.ui.controls.listClasses.ListDataFormatter";
	public function format(rawValue) {
		//如果是一个 Collection
		if(ClassUtil.isImplementationOf(rawValue.classOwner,Collection)){
			return new ListDataProvider(rawValue.toArray());
		}
		var _value_type:String = ObjectUtil.analyze(rawValue);
		switch (_value_type) {
		    case "array":
		   		return new ListDataProvider(rawValue);
		        break;
		    case "xml":
		    	var _dataSet:DataSet = new DataSet();
		    	_dataSet.ReadXml(rawValue.lastChild);
		    	var _l = _dataSet.Tables.length;
		    	var _arr:Array = new Array();
		    	for (var i : Number = 0; i < _l; i++) {
		    		_arr = _arr.concat(_dataSet.Tables[i].Rows);
		    	}
		    	return new ListDataProvider(_arr);
		        break;
		    case "xmlnode":
		    	var _dataSet:DataSet = new DataSet();
		    	_dataSet.ReadXml(new XML(rawValue).lastChild);
		    	var _l = _dataSet.Tables.length;
		    	var _arr:Array = new Array();
		    	for (var i : Number = 0; i < _l; i++) {
		    		_arr = _arr.concat(_dataSet.Tables[i].Rows);
		    	}
		    	return new ListDataProvider(_arr);
		        break;
		    case "object":
		    	return new ListDataProvider(new Array(rawValue));
		        break;
		    default:
		      	return new ListDataProvider();
		}
	}

	public function unformat(formattedValue) {
	}

}