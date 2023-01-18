/*
* Copyright (c) 2006 Michael Baczynski http://lab.polygonal.de
*
* Permission to use, copy, modify, distribute and sell this software
* and its documentation for any purpose is hereby granted without fee,
* provided that the above copyright notice appear in all copies.
* Michael Baczynski makes no representations about the suitability
* of this software for any purpose.
* It is provided "as is" without express or implied warranty.
*
* Description:
* A bitvector is meant to condense bit values (or booleans) into
* an array as close as possible so that no space is wasted.
*/
class com.tPS.array.BitVector
{
	private var _aBits:Array;
	private var _size:Number;
	private var _numBits:Number;

	/**
	 * Creates a bitvector to store a given number of bits.
	 */
	public function BitVector(bits:Number)
	{
		_aBits = [];
		_size = 0;
		resize(bits);
	}

	public function get bitCount():Number
	{
		return _size * 31;
	}

	public function get cellCount():Number
	{
		return _size;
	}

	public function getBit(index:Number):Number
	{
		var cell:Number = int(index / 31);
		var bit:Number = index % 31;
		return (_aBits[cell] & (1 << bit)) >> bit;
	}

	public function setBit(index:Number, b:Boolean)
	{
		var cell:Number = int(index / 31);
		var bit:Number = index % 31;
		var mask:Number = (1 << bit);

		if (b)
			_aBits[cell] = (_aBits[cell] | mask);
		else
			_aBits[cell] = (_aBits[cell] & (~mask));
	}

	public function resize(size:Number):Void
	{
		_numBits = size;

		if (size % 31 == 0)
            size /= 31;
        else
            size = (size / 31) + 1;

		var a:Array = [];

		var min:Number = Math.min(size, _size);

        for (var i:Number = 0; i < min; i++)
            a[i] = _aBits[i];

		_size = size;

		_aBits = a;
		delete a;
	}

	public function clearAll():Void
    {
        for (var i:String in _aBits)
			_aBits[i] = 0;
    }

	public function setAll():Void
    {
        for (var i:String in _aBits)
			_aBits[i] = 0xFFFFFFFF;
    }
}

