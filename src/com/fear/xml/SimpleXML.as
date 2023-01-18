import com.fear.core.CoreInterface;
import com.fear.util.ObjectUtil;

class com.fear.xml.SimpleXML extends XML{
	private var $context:Object;
	private var $instanceDescription:String;

	private var $timeLimit:Number;
	private var $loadCheckInterval:Number;
	private var $retries:Number;
	private var $filePath:String;
	private var $loadAttempts:Number;

	function SimpleXML(){
		super();
		this.ignoreWhite = true;
		this.setTimeLimit(1000);
		this.setRetries(2);
		this.setClassDescription('com.fear.xml.SimpleXML');
	}

	/*
	public function toString(Void):String{
		return this.$instanceDescription;
	}
	*/

	private function setClassDescription(d:String):Void{
		this.$instanceDescription = d;
	}

	//	accessor for private context var. 
	//	@returns Object.
	public function getContext():Object{
		return this.$context;
	}

	//	mutator for private context var. 
	//	@argument arg Object
	public function setContext(arg:Object){
		this.$context = arg;
	}

	//	Load method. Overloads the XML super class load.
	public function load(file:String):Void{
		if(ObjectUtil.isTypeOf(file, 'string') == false || ObjectUtil.isEmpty(file)){
			this.onLoadFailure();
			return;
		}
		this.$filePath = file;
		this.$loadAttempts++
		super.load(file);
	}

	public function onLoad(success:Boolean):Void{
		trace('Onload called for: ' + this.$filePath);
		_root.debug.text += 'Onload called for: ' + this.$filePath + "\n";
		if(!success){
			this.retryLoad();
		}else{
			this.onLoadSuccess();
		}
	}

	private function startLoadCheck(Void):Void{
		clearInterval(this.$loadCheckInterval);
		this.$loadCheckInterval = setInterval(this, 'retryLoad', this.getTimeLimit());
	}

	private function retryLoad(Void):Void{
		trace('retryLoad called.');
		/* keep retrying for now
		if(this.$loadAttempts >= this.$retries){
			trace('All out of retries...');
			this.onLoadFailure();
			return;
		}
		*/
		this.startLoadCheck();
		this.load(this.$filePath);
	}

	//	accessor for private $timeLimit var. 
	//	@returns Number.
	public function getTimeLimit():Number{
		return this.$timeLimit;
	}
	//	mutator for private $timeLimit var. 
	//	@argument arg Number
	public function setTimeLimit(arg:Number):Void{
		this.$timeLimit = arg;
	}
	//	accessor for private $retries var. 
	//	@returns Number.
	public function getRetries():Number{
		return this.$retries;
	}
	//	mutator for private $retries var. 
	//	@argument arg Number
	public function setRetries(arg:Number):Void{
		this.$retries = arg;
	}


	private function onLoadSuccess():Void{
		this.parse();
	}

	private function onLoadFailure():Void{
		clearInterval(this.$loadCheckInterval);
	}

	private function onParseSuccess():Void{}

	private function onParseFailure():Void{}

	public function parse():Void{
		//	overload this in the subclasses...
		this.onParseSuccess();
	}

}
