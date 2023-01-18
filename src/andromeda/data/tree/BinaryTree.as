/*

  The contents of this file are subject to the Mozilla Public License Version
  1.1 (the "License"); you may not use this file except in compliance with
  the License. You may obtain a copy of the License at 
  
           http://www.mozilla.org/MPL/ 
  
  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
  for the specific language governing rights and limitations under the License. 
  
  The Original Code is Vegas Framework.
  
  The Initial Developer of the Original Code is
  ALCARAZ Marc (aka eKameleon)  <vegas@ekameleon.net>.
  Portions created by the Initial Developer are Copyright (C) 2004-2007
  the Initial Developer. All Rights Reserved.
  
  Contributor(s) :
  
*/


import andromeda.data.tree.BinaryTreeNode;

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.core.IComparator;
import vegas.core.ISerializable;
import vegas.util.comparators.NumberComparator;

/**
 * A Binary tree {@code BinaryTree} register datas in a recursive manner so that you can access it quickly 
 * by using a key. 
 * <p>Therefore, a {@code BinaryTree} automatically sorts data as it is inserted.</p>
 * <p>For a {@code BinaryTree} to be valid, every node has to follow two rules:</p>
 * <p>
 * <li>The data value in the left subtree must be less than the data value in the current node.</li>
 * <li>The data value in the right subtree must be greater than the data value in the current node.</li>
 * </p> 
 * @author eKameleon
 * @see IComparator
 */
class andromeda.data.tree.BinaryTree extends CoreObject implements ICloneable, ISerializable 
{

	/**
	 * Creates a new BinaryTree instance.
	 * @param comp a IComparator object used in this tree to defined the sort model when insert or modify the tree.
	 */
	public function BinaryTree( comp:IComparator ) 
	{
		root = null ;
		setComparator( comp ) ;
	}
	
	/**
	 * The default IComparator used in the BinaryTree instances if the IComparator defined in the setComparator method is null.
	 */
	static public var DEFAULT_COMPARATOR:IComparator = new NumberComparator() ;

	/**
	 * The root Node of this BinaryTree.
	 */
	public var root:BinaryTreeNode ;
	
	/**
	 * Returns the shallow copy of this BinaryTree instance.
	 * @return the shallow copy of this BinaryTree instance.
	 */
	public function clone() 
	{
		return new BinaryTree() ;
	}

	/**
	 * Returns {@code true} if the BinaryTree contains the specified value.
	 * @return {@code true} if the BinaryTree contains the specified value.
	 */
	public function contains( data ):Boolean 
	{
        return _contains(root, data) ;
    }
    
    /**
	 * Returns the internal IComparator reference.
	 * @return the internal IComparator reference.
	 */
	public function getComparator():IComparator 
	{
		return _comparator ;
	}
    
    /**
     * Changes the tree by inserting a duplicate node on each node's left.
     */
    public function getDoubleTree():String
    {
    	var str:String = "\r## double tree\r\r" ;
    	str += _getDoubleTree( root ) ;
    	return str ;
    }

	/**
	 * Inserts the given data into the binary tree.
	 * {@code
	 * inst.insert(data);
	 * }
	 * @param a number value to be insert in the BinaryTree.
	 */
	public function insert( data ):Void 
	{
		root = _insert(root, data) ;
	}
	
    /**
     * Calls recursive lookup for input number.
     * @param data The data value to find.
     * @return {@code true} if the given target is in the binary tree.
    **/
    public function lookup( data ):Boolean
    {
        return _lookup( root, data ) ;
    }

	/**
	 * Recursive helper that iterates to the right to find the max value.
	 * @return the max value in a nom-empty binary search tree.
	 */
	public function max():Number 
	{
        return _max(root);
    }

	/**
	 * Uses a recursive helper that recurs down to find the max depth.
	 * @return the max root to leaf depth of the tree.
	 */
	public function maxDepth():Number 
	{
        return _maxDepth(root);
    }

	/**
	 * Uses a helper method that iterates to the left to find the min value.
	 * @return the min value in a non-empty binary search tree.
	 */
	public function min():Number 
	{
        return _min(root);
    }
    
   	/**
	 * Sets the IComparator reference of this object.
	 * @param comp the IComparator reference of this object.
	 */
	public function setComparator( comp:IComparator ):Void
	{
		_comparator = comp || DEFAULT_COMPARATOR ;
	}
	
	/**
	 * Returns the numbers of nodes in this tree.
	 * @return the numbers of nodes in this tree.
	 */
	public function size():Number 
	{
		return (root == null) ? 0 : root.size() ;
	}

    /**
     * Given a binary tree, prints out all of its root-to-leaf paths, one per line.
     * @return the string representation of the paths.
     */
    public function printPaths():String
    {
        var s = "\r## printPaths\r\r";
        var path:Array = new Array(1000);
        
        trace(">>>>> " + root + " : " + path + " : " + 0 ) ;
        
        s += _printPathsRecurs( root, path, 0 ) ;
        return s ;
    }

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		return "new tree.BinaryTree()" ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		var txt:String = "[BinaryTree]" ;
		txt += "\r" + _toString(root) ;
		return txt ;
	}

	/**
	 * The internal IComparator reference.
	 */
	private var _comparator:IComparator = null ;

	/**
	 * Returns {@code true} if the specified node contains the specified data.
	 * @return {@code true} if the specified node contains the specified data.
	 */
	private function _contains(node:BinaryTreeNode, data):Boolean 
	{
        if (BinaryTreeNode == null) 
        {
        	return false ;
        }
        var result:Number = _comparator.compare(data, node.data) ;
        if (result == 0 )
		{
        	return true ;
        }
        else if ( result == -1 ) 
        {
        	return _contains( node.left, data ) ;
        }
        else 
        {
        	return _contains( node.right, data ) ;
        }
    }
    
    private function _getDoubleTree( node:BinaryTreeNode ):String
    {
        var s:String = "doubleTreeRecurs\r" ;
        var oldLeft:BinaryTreeNode ;

        if (node==null) 
        {
        	return ;
        }

        // do the subtrees
        
        s += "doubleTreeRecurs.node.left\r";
        
        s += _getDoubleTree( node.left ) ;
        
        s += "doubleTreeRecurs.node.right\r";
        
        s += _getDoubleTree( node.right );

        oldLeft = node.left ;
        node.setLeft( new BinaryTreeNode( node.data ) ) ;
        node.left.setLeft( oldLeft ) ;
        
        return s ;
    }
	/**
	 * Recursive insert, given a BinaryTreeNode pointer, recursive down and insert the given data into the tree.
	 * @param BinaryTreeNode a BinaryTreeNode instance.
	 * @param data a real number.
	 * @return the new BinaryTreeNode pointer (the standard way to communicate a changed pointer back to the caller).
	 */
	private function _insert(node:BinaryTreeNode, data ):BinaryTreeNode 
	{
		if (node == null) 
		{
			node = new BinaryTreeNode(data) ;
		}
        else 
        {
        	var result:Number = _comparator.compare(data, node.data) ;
            if ( result > -1 ) 
            {
            	node.setRight( _insert(node.right, data) ) ;
            }
            else 
            {
            	node.setLeft( _insert(node.left, data) ) ;
            }
        }
        return node ;
    }
    
	/**
     * Recursive lookup, given a BinaryTreeNode, recur down searching for the given data.
     * @param BinaryTreeNode a BinaryTreeNode instance ($root).
     * @param data The data in the node.
     * @return a boolean if the data is find.
	 */
    private function _lookup( node:BinaryTreeNode, data ):Boolean
    {
        if ( BinaryTreeNode == null || _comparator == null )
        {
        	return false ;
        }
		var result:Number = _comparator.compare(data, node.data) ;
        if (result == 0)
        {
        	return true;
        }
        else if ( result == -1 )
        {
        	return _lookup( node.left,data)  ;
        }
        else 
        {
        	return _lookup( node.right, data );
        }
    }
	
	private function _maxDepth( node:BinaryTreeNode):Number 
	{
        if ( node == null)
        {
        	return 0 ;
        }
        else 
        {
            var l:Number = _maxDepth(node.left);
            var r:Number = _maxDepth(node.right);
            return Math.max(l, r) + 1 ;
        }
    }

	private function _max(node:BinaryTreeNode):Number 
	{
        var cur:BinaryTreeNode = node ;
		while (cur.right !=null ) 
		{
			cur = cur.right ;
		}
        return cur.data ;
    }

	private function _min(node:BinaryTreeNode):Number 
	{
        var cur:BinaryTreeNode = node ;
		while (cur.left !=null )
		{
			cur = cur.left ;
		}
        return cur.data ;
    }
  
   	private function _printArray( ar:Array , len:Number ):String
	{
		var s = "Print Array \r" ;
		for ( var i:Number = 0; i<len ; i++)
		{
			s += "# ints["+i+"] : " + ar[i] + "\r" ;
		}
		return s ;
	}
	
    private function _printPathsRecurs(node:BinaryTreeNode, path:Array, pathLen:Number):String
    {
        
        var s:String = "# printPathsRecurs\r";

        if (node == null) 
        {
        	return "" ;
        }

        // append this BinaryTreeNode to the path array
        
        trace("???? : " + node.data) ;
        
        path[pathLen] = node.data ;
        
        pathLen++ ;

        // it's a leaf, so print the path that led to here
        if (node.left == null && node.right == null )
        {
            s += _printArray( path , pathLen );
        }
        else
        {
            s += "# printPathsRecurs.node.left \r";
            s += _printPathsRecurs( node.left, path, pathLen ) || "" ;
            s += "# printPathsRecurs.node.right \r";
            s += _printPathsRecurs( node.right, path, pathLen ) || "";
        }
        return s ;
    }
    
	private function _toString( node:BinaryTreeNode ):String 
	{
		if ( node==null ) 
		{
			return "" ;
		}
        // left, BinaryTreeNode itself, right
		var txt:String = "" ;
        txt += "L --- " + _toString( node.left) + " : " + node.data + "\r" ; 
        txt += "R --- " + _toString( node.right) ;
		return txt ;
    }
    
   
	

}