/*
 * vim:et sts=4 sw=4 cindent:
 * $Id: Hash.as 247 2006-07-18 01:18:51Z allens $
 */

import com.stamen.data.*;

class com.stamen.data.Hash extends Object
{
    private var _values:Array;

    public function Hash(values:Object)
    {
        this._values = new Array();
        for (var k:String in values)
            this.setValue(k, values[k]);
    }

    public function copy():Hash
    {
        return new Hash(this);
    }

    public function toString():String
    {
        return this._values.toString();
    }

    public function hasKey(k:String):Boolean
    {
        return (null != this[k]);
    }

    public function getOrSet(k:String, value:Object)
    {
        if (!this.hasKey(k))
            this.setValue(k, value);
        return this.getValue(k);
    }

    public function getValue(k:String)
    {
        return this[k];
    }

    public function setValue(k:String, value:Object)
    {
        var old = this.getValue(k);
        this.deleteKey(k);
        this[k] = value;
        this._values.push([k, value]);
        return old;
    }

    public function deleteKey(k:String):Void
    {
        var len:Number = this._values.length;
        for (var i:Number = 0; i < len; i++)
        {
            if (this._values[i][0] == k)
            {
                this._values.splice(i, 1);
                break;
            }
        }

        this[k] = null;
        delete this[k];
    }

    public function update(obj:Object):Void
    {
        for (var k:String in obj)
        {
            if (null == obj[k])
            {
                this.deleteKey(k);
                continue;
            }
            this.setValue(k, obj[k]);
        }
    }

    public function get length():Number
    {
        return this._values.length;
    }

    public function get keys():Array
    {
        var keys:Array = new Array();
        for (var i:Number = 0; i < this._values.length; i++)
        {
            keys.push(this._values[i][0]);
        }
        return keys;
    }

    public function get values():Array
    {
        var values:Array = new Array();
        var len:Number = this._values.length;
        for (var i:Number = 0; i < len; i++)
        {
            values.push(this._values[i][1]);
        }
        return values;
    }
}
