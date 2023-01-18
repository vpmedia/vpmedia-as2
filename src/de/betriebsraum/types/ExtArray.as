/**
 * Extended Array.
 *
 * @author: Christoph Asam, E-Mail: c.asam@betriebsraum.de, Url: http://www.betriebsraum.de
 * @version: 1.0
 */
 
class de.betriebsraum.types.ExtArray extends Array
{
	private var _rows:Number;
	private var _cols:Number;
	private var _twoDArray:Array;
	
	public function ExtArray(){

		if(arguments[0][0] != undefined){
			
			this._rows = arguments[0].length;
			this._cols = arguments[0][0].length;
			this._twoDArray = arguments;
			
			var cnt = 0
			var i:Number = -1;
			
			
			while(++i < this._rows){
				
			
				var j:Number = -1;
				
				while(++j < this._cols){
					
					this[cnt] = arguments[0][i][j];
					cnt++;
					
				}
			}
			

		} else trace("No 2D Array");
		
		
	}
	
	public function get rows():Number{
		return this._rows;
	}
	
	public function get cols():Number{
		return this._cols;
	}
	
	public function get twoDArray():Array{
		return this._twoDArray;
	}
	

	public function getItemAt(row,col){
		
		return this[this.getPosByRowCol(row,col)];
		
	}
	
	public function replaceItemAt(row,col,item){
		
		var tmp = this[this.getPosByRowCol(row,col)];
		
		this[this.getPosByRowCol(row,col)] = item;
		
		return tmp;
	}
		
	public function removeItemAt(row,col){
		
		var tmp = this[this.getPosByRowCol(row,col)];
		
		this[this.getPosByRowCol(row,col)] = null;
		
		return tmp
		
	}
	
	public function getRowAt(pos:Number):Array{
		
		var tmp = this.slice((pos*this._cols),(pos*this._cols +this._cols));
		
		return tmp;
		
	}
	
	public function insertRowAt(pos:Number,arg:Array):Array{

		if(arg.length == this._cols){
			var tmp = this.splice((pos*this._cols),this.length);
			
			var i:Number = -1
			
			while(++i < arg.length){
				this.push(arg[i])
			}
			
			i = -1;
			
			while(++i < tmp.length){
				this.push(tmp[i])
			}
			
			return this;
		} else trace("Warning: Row has different length");
		
	}
	
	public function replaceRowAt(pos:Number,arg:Array):Array{

		if(arg.length == this._cols){
			
			var tmp:Array = this.removeRowAt(pos);
			
			this.setNewRowAt(pos,arg);
			
			return this;
			
		} else trace("Warning: Row has different length");
		
	}
	
	public function removeRowAt(pos:Number):Array{
		
		var tmp = this.slice((pos*this._cols),(pos*this._cols + this._cols));
		
		this.splice((pos*this._cols),(this._cols));
		
		return tmp;
		
	}

	public function getColAt(pos:Number):Array{
		
		var tmp:Array = new Array();
		var i:Number = -1;
		
		while(++i<this.length){
		
			if(this.getPosByIndex(i).col == pos){
				tmp.push(this[i]);
			}
		}		
		
		return tmp;
		
	}
	
	public function insertColAt(pos:Number,arg:Array):Array{
		
		if(arg.length == this._rows){
			var tmp:Array = new Array();
			var i:Number = -1;
			var cnt:Number = 0;
			
			while(++i < this.length){
				
				if(this.getPosByIndex(i).col == pos){

					this.splice(i+cnt,0,arg[cnt]);
					cnt++
					if(cnt == arg.length){
						return this;
					}
				}
			}
	
			
			
		} else trace("Warning: Column has different length");
		
	}
	
	public function replaceColAt(pos:Number,arg:Array):Array{
		
		if(arg.length == this._rows){

			var tmp:Array = this.removeColAt(pos);
			
			this.setNewColAt(pos,arg);
			
			return this;
			
		} else trace("Warning: Column has different length");
		
	}
	
	public function removeColAt(pos:Number):Array{
		
		var tmp:Array = new Array();
		var i:Number = -1;
		var cnt:Number = 0;
		
		while(++i < this.length){
			
			if(this.getPosByIndex(i).col == pos){
				tmp.push(this.splice(i-cnt,1));
				cnt++;
			}			
		}
		
		return tmp;
		
	}
	
	public function getPosByRowCol(row,col):Number{

		return row * this._cols + col;
		
	}
	
	public function getPosByIndex(index:Number):Object{
		
		return {row:Math.floor(index/this._cols),col:index%this._cols}
		
	}	
	
}