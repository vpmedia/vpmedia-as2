/**
 * CustomArray
 * Copyright © 2006 András Csizmadia
 * Copyright © 2006 VPmedia
 * http://www.vpmedia.hu
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 * 
 * Project: CustomArray
 * File: CustomArray.as
 * Created by: András Csizmadia
 *
 */
// Implementations
import com.vpmedia.core.IFramework;
class com.vpmedia.CustomArray extends Array implements IFramework
{
	// START CLASS
	/**
	 * <p>Description: Decl.</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public var className:String = "CustomArray";
	public var classPackage:String = "com.vpmedia";
	public var version:String = "2.0.0";
	public var author:String = "András Csizmadia";
	// constructor
	function CustomArray ()
	{
		// super.constructor.apply(this, arguments);
		splice.apply (this, [0, 0].concat (arguments));
	}
	// remove item by index from array
	public function removeByIndex (ind:Number):Void
	{
		delete this[ind];
	}
	// offset
	public function offset (amount:Number):Array
	{
		amount = -amount % this.length;
		return (amount) ? this.slice (amount).concat (this.slice (0, amount)) : this.slice ();
	}
	// randomises the array
	public function shuffle ():Void
	{
		var len:Number = this.length;
		var rand:Number;
		var temp;
		for (var i = 0; i < len; i++)
		{
			rand = Math.floor (Math.random () * len);
			temp = this[i];
			this[i] = this[rand];
			this[rand] = temp;
		}
	}
	/* clones the array */
	public function copy ():Array
	{
		var aTemp:Array = new Array ();
		if (this.length == 0)
		{
			for (var i in this)
			{
				aTemp[i] = this[i];
			}
		}
		for (var i = 0; i < this.length; i++)
		{
			aTemp[i] = this[i];
		}
		return aTemp;
	}
	/*	is contain item from array
	*/
	public function contains (obj):Boolean
	{
		for (var i in this)
		{
			if (this[i] == obj)
			{
				return true;
			}
		}
		return false;
	}
	/* array summary
	*/
	public function sum ():Number
	{
		var sum = 0;
		for (var i in this)
		{
			sum += this[i];
		}
		return sum;
	}
	/* convert array string
	*/
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	/* Sorts the numerical array. The array can be sort in either ascending or decending order. 
	 *  USAGE: array.numSort(boolean); d = if true, returns decending array
	 */
	public function numSort (d)
	{
		this.ascend = function (a, b)
		{
			return a > b;
		};
		this.descend = function (a, b)
		{
			return a < b;
		};
		if (d == true)
		{
			this.sort (this.descend);
		}
		else
		{
			this.sort (this.ascend);
		}
	}
	// USAGE: array.areConsecutive(); * Requires the numSort prototype. *
	// Checks that if the numerical values in the array are consecutive. Returns true or false.
	public function areConsecutive ()
	{
		this.numSort ();
		for (var i = 0; i < this.length - 1; i++)
		{
			if (this[i + 1] != this[i] + 1)
			{
				return false;
			}
		}
		return true;
	}
	// USAGE: array.hasOfAKind(number); a = how many? / * Requires the countValues prototype. *
	// Checks that if the array has (a) of a kind. Returns true or false.
	public function hasOfAKind (a)
	{
		for (var i = 0; i < this.length; i++)
		{
			if (this.countValues (this[i]) == a)
			{
				return true;
			}
		}
		return false;
	}
	// USAGE: array.areIdentical();
	// Checks that are all the array values identical. Returns true or false.
	public function areIdentical ()
	{
		for (var i = 0; i < this.length; i++)
		{
			for (var j = 0; j < this.length; j++)
			{
				if (this[i] != this[j])
				{
					return false;
				}
			}
		}
		return true;
	}
	// USAGE: array.toNumbers();
	// Converts all string values in a array to numbers. Returns nothing.
	public function toNumbers ()
	{
		for (var i = 0; i < this.length; i++)
		{
			this[i] = Number (this[i]);
		}
	}
	// USAGE: array.getResultIndeces(value);
	// Searches specified arguments from the array and returns their indeces in an array.
	public function getResultIndeces (v)
	{
		var a = new Array ();
		for (var i = 0; i < this.length; i++)
		{
			if (this[i] == v)
			{
				a.push (i);
			}
		}
		if (a.length == 0)
		{
			return false;
		}
		else
		{
			return a;
		}
	}
	// USAGE: array.makeUnique();
	// Removes all duplicate values from the array. Requires the removeElement prototype.
	public function makeUnique ()
	{
		for (var i = 0; i < this.length; i++)
		{
			var s = this[i];
			for (var j = 0; j < this.length; j++)
			{
				if (s == this[j] && j != i)
				{
					this.removeElement (i);
				}
			}
		}
	}
	// USAGE: array.makeEmpty();
	// Clears the array from all values and indeces. Returns nothing.
	public function makeEmpty ()
	{
		while (this.length > 0)
		{
			this.pop ();
		}
	}
	// USAGE: array.countValues(value); v = value;
	// Counts the specified values in the array. Returns the count.
	public function countValues (v)
	{
		var c = 0;
		for (var i = 0; i < this.length; i++)
		{
			if (this[i] == v)
			{
				c++;
			}
		}
		return c;
	}
	// USAGE: array.rollAround();
	// Moves the array around. The first element goes to last.
	public function rollAround (i)
	{
		this.push (this[0]);
		this.shift ();
	}
	// USAGE: array.removeElement(number); i = element id
	// Removes the specified array element and returns the removed element's value.
	public function removeElement (i)
	{
		if (i == null)
		{
			i = 0;
		}
		var r = this[i];
		for (var j = i; j < this.length - 1; j++)
		{
			this[j] = this[j + 1];
		}
		this.pop ();
		return r;
	}
	// USAGE: array.removeValues(value); a = value
	// Removes the specified array value('s). Requires the removeElement prototype.
	public function removeValues (a)
	{
		for (var i = 0; i < this.length; i++)
		{
			if (a == this[i])
			{
				this.removeElement (i);
			}
		}
	}
	// USAGE: array.getSum();
	// Calculates the sum of all values in an array. Returns the sum.
	public function getSum ()
	{
		var n = 0;
		for (var i = 0; i < this.length; i++)
		{
			n += this[i];
		}
		return n;
	}
	// USAGE: array.replaceValues(value,value);
	// Replaces all array values ([r]'s) with [w]'s. r = replace / w = with this .. :)
	public function replaceValues (r, w)
	{
		for (var i = 0; i < this.length; i++)
		{
			if (this[i] == r)
			{
				this[i] = w;
			}
		}
	}
	// USAGE: new_string = array.getRandomEntry();
	// Returns a random array value. Don't have to type it anymore. ;)
	public function getRandomEntry ()
	{
		return this[Math.floor (Math.random () * this.length)];
	}
	// USAGE: new_array = array.getOrganized();
	// This sorts an array full of named elements to a new numbered array.
	public function getOrganized ()
	{
		var a = new Array ();
		for (var i in this)
		{
			if (i != "organize" && typeof this[i] == "string" || typeof this[i] == "number")
			{
				a.push (this[i]);
			}
		}
		a.reverse ();
		return a;
	}
	// USAGE: array.hasValue(value); a = value
	// Checks that does the array have the [a]. If not, adds it. Returns true or false.
	public function hasValue (a)
	{
		for (var i = 0; i < this.length; i++)
		{
			if (a == this[i])
			{
				return true;
			}
		}
		this.push (a);
		return false;
	}
	// USAGE: new_array = array.searchFor(string); a = search arguments
	// Searches thru the array for [a]'s and returns the values in an new array.
	public function searchFor (a)
	{
		if (a == null)
		{
			return false;
		}
		var r = new Array ();
		for (var j = 0; j < this.length; j++)
		{
			var t = this[j].split (a);
			if (t.length > 1)
			{
				r.push (this[j]);
			}
		}
		return r;
	}
	// USAGE: array.insertTo(number,value); i = element id / v = value
	// Inserts the value to the specified element, moves the rest. Returns nothing.
	// If the element id isn't set the function will push the value into the first element.
	public function insertTo (i, v)
	{
		if (v == null)
		{
			v = false;
		}
		if (i == null)
		{
			i = 0;
		}
		for (var j = this.length; j > i; j--)
		{
			this[j] = this[j - 1];
		}
		this[i] = v;
	}
	// USAGE: array.cutInHalf (number); i = element id
	// Cuts the array with the specified id, removes the rest. Returns nothing.
	public function cutInHalf (i)
	{
		if (i == null)
		{
			i = 0;
		}
		for (var j = this.length; j > i; j--)
		{
			this.pop ();
		}
	}
	// USAGE: array.randomSuffle();
	// Suffles the array. Returns nothing.
	public function randomSuffle ()
	{
		var n = new Array ();
		while (this.length > 0)
		{
			var r = Math.floor (Math.random () * this.length);
			n.push (this[r]);
			for (var i = r; i < this.length; i++)
			{
				this[i] = this[i + 1];
			}
			this.pop ();
		}
		for (var i = 0; i < n.length; i++)
		{
			this.splice (0, 0, n[i]);
		}
	}
	// public function get(arg0,arg1,...,argn);
	// This is the replacement for get the value of a multidimensional array..
	// Instead of using: value = myArray[0][1][2][3][4], you can use: value = myArray.get(0,1,2,3,4)
	// Usage: array.get(value_to_insert, key1, key2...);
	public function get ()
	{
		if (arguments[0] instanceof Array)
		{
			arguments = arguments[0];
		}
		return arguments.length == 1 ? this[arguments[0]] : this[arguments[0]].get (arguments.splice (1));
	}
	// public function insertAt(value,arg0,...,argn);
	// Insert a value into a multidimensional array
	// creating keys in case they don't exist.
	// Usage: array.insertAt(value_to_insert, key1, key2...);
	public function _$insertAt ()
	{
		if (!(arguments[0].length > 0))
		{
			return;
		}
		var value = arguments[1];
		arguments = arguments[0];
		while (arguments.length > 0)
		{
			var _$key = arguments[0];
			if (!(this[_$key] instanceof Array))
			{
				this[_$key] = new Array ();
			}
			if (arguments.length < 2)
			{
				this[_$key] = value;
				return;
			}
			arguments.splice (0, 1);
			var _$args = arguments.splice (0);
			this[_$key]._$insertAt (_$args, value);
		}
	}
	public function insertAt (value)
	{
		this._$insertAt (arguments.splice (1), value);
	}
	// ===========================================
	// Example usage:
	// my_array = [[0, 0], [0, 0]];
	// my_array.insertAt ("mamma mia!", 1, 1, 5, 8, 7, 9, 10);
	//   JoinArrays
	//   intersect every element of 1st array with
	// all elements of array2
	//   usage:
	//   array = array.joinArrays(array1,array2)
	// example:
	// ArrayOne = new Array("1", "2", "3", "4", "5", "6");
	// ArrayTwo = new Array("a", "b", "c", "d");
	// ArrayThree = new Array();
	// ArrayThree.joinArrays(ArrayOne, ArrayTwo);
	//   ***************************************
	public function joinArrays (ArrayName1, ArrayName2)
	{
		for (var x = 0; x < ArrayName1.length; x++)
		{
			for (var i = 0; i < ArrayName2.length; i++)
			{
				this.push (Number (ArrayName1[x]) + String (ArrayName2[i]));
			}
		}
		return this;
	}
	// public function insert(index,value)
	// insert a value in a specified index position in the array without overwrite other keys
	// usage:
	// Array.insert(index, value)
	// example:
	// a = [1,2,3,4]
	// b = a.insert(1,'foo')
	// --> b = [1,'foo',2,3,4]
	// ***********************************
	public function insert (index, value)
	{
		if (!(index >= 0))
		{
			return;
		}
		var original = this.slice ();
		var temp = original.splice (index);
		original[index] = value;
		original = original.concat (temp);
		return original;
	}
	//	Usage:
	// ArrayOne = new Array("1", "2", "3", "4", "5", "6");
	// ArrayTwo = new Array("2", "4", "6", "8", "10", "12");
	// ArrayThree = new Array();
	// ArrayThree.SumArrays(6, ArrayOne, ArrayTwo);*/
	public function SumArrays (ArraysNumElements, ArrayName1, ArrayName2)
	{
		for (x = 0; x < ArraysNumElements; x++)
		{
			this[x] = Number (ArrayName1[x]) + Number (ArrayName2[x]);
			trace (this[x]);
		}
	}
	/* // usage
	alunni = new Array();
	alunni.set("Davide=>Finocchietti");
	alunni.set("Alessandro=>Crugnola");
	alunni.set("Davide=>Beltrame");
	alunni.set("Luca=>Ugliola");
	*/
	public function set ()
	{
		arguments = arguments[0].split ("=>");
		if (this.indexOf (arguments[0]) == null)
		{
			this.push (arguments[0]);
			if (!(Number (arguments[1])))
			{
				this.push (arguments[1]);
			}
			else
			{
				this.push (Number (arguments[1]));
			}
		}
		else
		{
			var j = this.indexOf (arguments[0]);
			this[j + 1] = arguments[1];
		}
	}
	// SAMPLE
	// arr = new Array("a","b","c","","","f")
	// trace(arr.noEmpty())
	public function NoEmpty ()
	{
		var num;
		for (var a = 0; a < this.length; a++)
		{
			if (this[a] != undefined && this[a] != "")
			{
				num++;
			}
		}
		return num;
	}
	/*score = [1,5,5,6,5,8,5,6,9,8,6];
	highest = score.mostFrequentOccurrence();
	trace(highest);*/
	public function mostFrequentOccurrence ()
	{
		var myArray = new Array ();
		var x = 0;
		for (var i = 0; i < this.length; i++)
		{
			var current = this[i];
			var c = 0;
			for (var j = 0; j < this.length; j++)
			{
				if (this[j] == current)
				{
					c++;
					myArray[x] = c;
				}
			}
			if (myArray[x - 1] <= myArray[x] || myArray[x - 1] == undefined)
			{
				var most = current;
				x++;
			}
		}
		return most;
	}
	/*
	usage:
	ourArray = new Array("This", "is", "my", "prototype");
	// define now our global variables into list function: ex. a,b,c,d 
	ourArray.list("a", "b", "c", "d");
	trace(a);
	trace(b);
	trace(c);
	trace(d);
	*/
	public function list ()
	{
		var i = 0;
		var myArray = new Array ();
		while (i < this.length)
		{
			_global[arguments[i]] = this[i];
			i++;
		}
	}
	// Shuffle our arrays by kingdavid:
	// www.adora.it - info@adora.it
	public function shuffle2 ()
	{
		var myArray = new Array ();
		for (var i = 0; i < this.length; i++)
		{
			var control = true;
			while (control)
			{
				var j = int (random (this.length));
				if (myArray[j] == undefined)
				{
					myArray[j] = this[i];
					control = false;
				}
			}
		}
		return myArray;
	}
	/*
	ourArray = new Array("This", "is", "our", "Array");
	shuffled = ourArray.shuffle();
	trace(shuffled);
	*/
	// this is for whom came from Director, which starts indexing
	// the array from 1 instead 0 as AS, and uses the getAt 
	// function to retreive a value from the array
	public function getAt (a)
	{
		return this[a - 1];
	}
	//   Array.d_concat
	//   Returns a new array containig only elements not present in both arrays
	/*
	//   usage:
	a1 = [1, 2, 3, 4, 5, 3, 3, 3, 3, 3, 3, 3, 'n', 'ma', 'pippo', 'pluto', 'topolino', 'minni', 'paperoga', 'macromedia', 'mm'];
	a2 = [0, 1, 0, 2, 0, 5, 6, 8, 1];
	result = a1.d_concat (a2);
	*/
	public function d_concat (secondArray)
	{
		if (arguments[0] == undefined)
		{
			return new Array ();
		}
		if (!(secondArray instanceof Array))
		{
			secondArray = [secondArray];
		}
		var niceArray = [];
		var tmpArray = [];
		//   ------------------
		//   first Array checks
		//   ------------------
		for (var a = 0; a < this.length; a++)
		{
			var firstAllow = true;
			for (var b = 0; b < secondArray.length; b++)
			{
				if (this[a] == secondArray[b])
				{
					firstAllow = false;
					break;
				}
			}
			if (firstAllow)
			{
				var allowInsert = true;
				for (var c = 0; c < tmpArray.length; c++)
				{
					if (this[a] == tmpArray[c])
					{
						allowInsert = false;
						break;
					}
				}
				if (allowInsert)
				{
					niceArray.push (this[a]);
					tmpArray.push (this[a]);
				}
			}
		}
		for (var a = 0; a < secondArray.length; a++)
		{
			var firstAllow = true;
			for (var b = 0; b < this.length; b++)
			{
				if (secondArray[a] == this[b])
				{
					firstAllow = false;
					break;
				}
			}
			if (firstAllow)
			{
				var allowInsert = true;
				for (var c = 0; c < tmpArray.length; c++)
				{
					if (secondArray[a] == tmpArray[c])
					{
						allowInsert = false;
						break;
					}
				}
				if (allowInsert)
				{
					niceArray.push (secondArray[a]);
					tmpArray.push (secondArray[a]);
				}
			}
		}
		return niceArray;
	}
	//   Array.s_concat()
	//   Return a new array containings only the items presents in the two array passed
	//   usage:
	//   Array.s_concat(compareArray);
	/*
	//   EXAMPLE
	a1 = ['a', 'b', 'b', 'c', 'a'];
	a2 = ['1', '2', 'a', 'a', 'c','C','b'];
	result = a1.s_concat(a2);
	*/
	public function s_concat (secondArray)
	{
		if (arguments[0] == undefined)
		{
			return new Array ();
		}
		if (!(secondArray instanceof Array))
		{
			secondArray = [secondArray];
		}
		var niceArray = [];
		var usedItems = [];
		for (var a = 0; a < this.length; a++)
		{
			for (var b = 0; b < secondArray.length; b++)
			{
				if (this[a] == secondArray[b])
				{
					var allowInsert = true;
					for (var c = 0; c < usedItems.length; c++)
					{
						if (this[a] == usedItems[c])
						{
							allowInsert = false;
							break;
						}
					}
					if (allowInsert)
					{
						niceArray.push (this[a]);
						usedItems.push (this[a]);
					}
					break;
				}
			}
		}
		return niceArray;
	}
	// array.search( value [, from, strict])
	// - value: value to search
	// - from: starting position
	// - strict: boolean value. if true it will search also if type of values corresponds
	/*
	a = [0,1,2,3,4,5,'',7,"0",1]
	b = "0"
	result = a.search(b) // return 0
	result2 = a.search(b,0,true) // return 8
	result3 = a.search(b,9) // return -1
	*/
	public function search (ago, from, strict)
	{
		if (from == undefined || from >= this.length)
		{
			from = 0;
		}
		strict = strict == undefined ? false : strict;
		for (var a = from; a < this.length; a++)
		{
			if (this[a] == ago)
			{
				if (strict)
				{
					if (this[a].__proto__ == ago.__proto__)
					{
						return a;
					}
				}
				else
				{
					return a;
				}
			}
		}
		return -1;
	}
	// This function is useful for mixing  the components of an array. If the array is empty and you don't pass any parameter,
	// the array assumes the dafault value of 10 numbers in mixted order. Anyway, if the array is empty and you
	// pass a numerical parameter, the function assumes the value of that parameter and it mixes as many numbers as you suggested.
	// Utilization:
	// - when you need to have a random numerical list without any repetition
	// - when you have to mix your array like a cards pack
	// Syntax
	// myArray.randoMix(rdm)
	// Parameter: rdm <- numbers to distribute in random order
	// Examples.
	/*
	arr1 = new Array("one", "two", "three", "four", "five");
	arr1.randoMix();
	trace(arr1);
	
	arr2 = new Array();
	arr2.randoMix();
	trace(arr2);
	
	arr3 = new Array();
	arr3.randoMix(20);
	trace(arr3);
	*/
	public function randoMix (rdm)
	{
		if (this.length < 1)
		{
			if (rdm == null || rdm < 0)
			{
				rdm = 10;
			}
			for (var c = 0; c < rdm; c++)
			{
				this[c] = c + 1;
			}
		}
		rdm = this.length;
		for (var i = 0; i < rdm; i++)
		{
			var rdMix = random (rdm);
			this.__$temp = this[rdMix];
			this.push (this.__$temp);
			this.splice (rdMix, 1);
			rdm--;
		}
	}
	// Description: This function remove the empty element  from an array
	// Usage: arrayname.clean(to_delete)
	// Parameter: to_delete <- element to delete from the array
	public function clean (to_delete)
	{
		var a;
		for (a = 0; a < this.length; a++)
		{
			if (this[a] == to_delete)
			{
				this.splice (a, 1);
				a--;
			}
		}
		return this;
	}
	//   Remove all duplicates in array
	//   case sensitive: array.removeDuplicates("s")
	//   case insensitive: array.removeDuplicates("i")
	public function removeDuplicates (c)
	{
		var i, j, temp;
		if (c == undefined)
		{
			c = true;
		}
		temp = this.slice ();
		for (var i = 0; i < temp.length; i++)
		{
			for (j = 0; j < temp.length; j++)
			{
				if ((c == true ? temp[j] : temp[j].toLowerCase ()) == (c == true ? temp[i] : temp[i].toLowerCase ()) && i != j)
				{
					temp.splice (j, 1);
					j--;
				}
			}
		}
		return temp;
	}
	//   ----------------
	//   USAGE
	// originary_array = ["A","B","A","C","C","D","G","J","j","K","A"];
	// alteredArray = originary_array.removeDuplicates('i'); // case insensitive
	// trace("Original: " + originary_array);
	// trace("Altered: " + alteredArray);
	// Array.repl - v 1.1
	// Search (and optionally replace)  
	// an element into an array  
	// This function is case-sensitive
	// Usage sample
	// Create the array(s) to examine
	// arr = new Array("Hello","world","How","are","you","?","Hello")
	// arr2 = new Array(1,2,3,4,5,6,79)
	// trace("Original array 1: " + arr)
	// trace("Original array 2: " + arr2)
	// Replace an element of array and return new array
	// trace("Replace an element and return the mod array: "
	// +arr.repl("Hello","***"))
	// trace("Replace an element and return the mod array (2): "
	// +arr2.repl("79","Was"))
	// Istructions
	// Syntax: Array.repl("toSearch","Replace")
	// Array 
	// <- the Array to examine (needed)
	// toSearch 
	// <- Element to search into the array (needed)
	// Replace 
	// <- Element that replace the searched object in the array (optional)
	// The function return the position of searched element in the array. If you insert "replace" parameter (for replace the searched element in the array), orginal array has mod
	public function repl ()
	{
		var toSearch, toReplace, a;
		toSearch = arguments[0];
		toReplace = arguments[1];
		if (toSearch == "")
		{
			return null;
		}
		for (a = 0; a < this.length; a++)
		{
			if (this[a] == toSearch)
			{
				this[a] = toReplace;
			}
		}
		return this;
	}
	/*
	 Sort multiple array according to the first array
	 If you have many arrays and you want to sort one of this mantaining the reference of all the others arrays unchanged use this function.
	 array.multipleSort(array1[,array2,...,arrayn])
	usage example 1:
	sorting two arrays
	first = new Array("Elisa","Alberto","Alessandro","Gertrud","andrea");
	second = new Array("crugnola","danieli","crugnola","buckl","Gamberoni");
	first.multipleSort(second);
	*/
	public function multipleSort ()
	{
		var mysort;
		var masterArray = new Array ();
		for (var a = 0; a < this.length; a++)
		{
			masterArray[a] = new Array ();
			masterArray[a][0] = this[a];
			for (var b = 1; b <= arguments.length; b++)
			{
				masterArray[a][b] = arguments[b - 1][a];
			}
		}
		mysort = function (element1, element2)
		{
			element1 = element1[0].toUpperCase ();
			element2 = element2[0].toUpperCase ();
			return element1 > element2;
		};
		masterArray.sort (mysort);
		for (var a = 0; a < masterArray.length; a++)
		{
			this[a] = masterArray[a][0];
			for (var b = 1; b < masterArray[a].length; b++)
			{
				arguments[b - 1][a] = masterArray[a][b];
			}
		}
	}
	/*  Sort alphabetically case insensitive
	*/
	public function asort ()
	{
		var myfn;
		myfn = function (element1, element2)
		{
			element1 = element1.toUpperCase ();
			element2 = element2.toUpperCase ();
			return element1 > element2;
		};
		return this.sort (myfn);
	}
	// max
	public function maxValue ()
	{
		for (var i = 0; i < this.length - 1; i++)
		{
			this[i + 1] = this[i] > this[i + 1] ? this[i] : this[i + 1];
		}
		return this[this.length - 1];
	}
	// min
	public function minValue ()
	{
		for (var i = 0; i < this.length - 1; i++)
		{
			this[i + 1] = this[i] < this[i + 1] ? this[i] : this[i + 1];
		}
		return this[this.length - 1];
	}
	// average
	public function average ()
	{
		var total = 0;
		for (var i = 0; i < this.length; i++)
		{
			total += this[i];
		}
		return total / this.length;
	}
	// index of
	public function firstIndexOf (arg)
	{
		var p = -1, v;
		for (v in this)
		{
			this[v] == arg ? p = v : null;
		}
		return (p);
	}
	public function lastIndexOf (arg)
	{
		var p = -1, v;
		for (v in this)
		{
			if (this[v] == arg)
			{
				p = v;
				break;
			}
		}
		return (p);
	}
	//
	public function lastElement ()
	{
		return this[this.length - 1];
	}
	//
	public function mySum (elem)
	{
		if (!elem)
		{
			elem = this.length;
		}
		for (var i = 0, sum = 0; i <= elem; i++)
		{
			sum += this[i];
		}
		return (sum);
	}
	//
	public function rand (pValue)
	{
		if (pValue > this.length)
		{
			return this;
		}
		if (pValue == undefined || pValue < 2)
		{
			return this[Math.floor (Math.random () * this.length)];
		}
		else
		{
			var tmp = this.slice ();
			var result = [];
			for (var i = 0; i < pValue; i++)
			{
				result.push (tmp.splice (Math.floor (Math.random () * tmp.length), 1));
			}
			return result;
		}
	}
	//
	public function removeItem (item)
	{
		for (var n = 0; n < this.length; n++)
		{
			if (this[n] == item)
			{
				this.splice (n, 1);
				return;
			}
		}
	}
	//
	public function iterate (input:Function, reverse:Boolean, target:Object)
	{
		if (target == undefined)
		{
			target = this;
		}
		if (reverse == undefined)
		{
			reverse = false;
		}
		if (reverse)
		{
			var i = this.length;
			while (i--)
			{
				input.apply (target, [i, this[i]]);
			}
		}
		else
		{
			for (var i = 0; i < this.length; i++)
			{
				input.apply (target, [i, this[i]]);
			}
		}
	}
	/**
	 * <p>Description: Get Class version</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function getVersion ():String
	{
		//trace ("%%" + "getVersion" + "%%");
		var __version = this.version;
		return __version;
	}
	/**
	 * <p>Description: Get Class name</p>
	 *
	 * @author András Csizmadia
	 * @version 1.0
	 */
	public function toString ():String
	{
		return ("[" + className + "]");
	}
	// END CLASS	
}
