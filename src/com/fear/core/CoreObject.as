import com.fear.core.CoreInterface;
import com.fear.util.ObjectUtil;

class com.fear.core.CoreObject implements CoreInterface{
	private var $instanceDescription:String;
	public function CoreObject(Void){
		this.setClassDescription('com.fear.core.CoreObject');
	}
	public function toString(Void):String{
		return this.$instanceDescription;
	}
	private function setClassDescription(d:String):Void{
		this.$instanceDescription = d;
	}
}
