class SampleData {
	
	static private var bigDataSet:Array;
	
	static public function getBigDataSet() : Array {
		if(bigDataSet==undefined) {
			bigDataSet = new Array();
			for(var n=0; n<12; n++) {
				bigDataSet.push( { id:n, name:"Item "+(n+1) } );
			}
		}
		return bigDataSet;
	}
}