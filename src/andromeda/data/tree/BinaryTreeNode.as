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

import vegas.core.CoreObject;
import vegas.core.ICloneable;
import vegas.core.ICopyable;
import vegas.core.ISerializable;

/**
 * A binary tree node from which you can build a binary tree.
 * <p>A Binary Tree is a simplified tree structure in which every node is only allowed to have up 
 * to two children nodes, which are called the left and right child.</p>
 */
class andromeda.data.tree.BinaryTreeNode extends CoreObject implements ICloneable, ICopyable, ISerializable 
{

	/**
	 * Creates a BinaryTreeNode instance.
	 * @param data The data to register inside the node.
	 */
	public function BinaryTreeNode( data ) 
	{
		this.left   = null ;
		this.right  = null ;
		this.parent = null ;
		this.data  = data ;
	}

	/**
	 * The data of this node.
	 */
	public var data ;

	/**
	 * The left BinaryTreeNode of this node.
	 */
	public var left:BinaryTreeNode ;

	/**
	 * The parent BinaryTreeNode of this node.
	 */
	public var parent:BinaryTreeNode ;
	
	/**
	 * The right BinaryTreeNode of this node.
	 */
	public var right:BinaryTreeNode ;
	
	/**
	 * Returns a shallow copy of this object.
	 * @return a shallow copy of this object.
	 */
	public function clone() 
	{
		return new BinaryTreeNode(data) ;
	}

	/**
	 * Returns a deep copy of this object.
	 * @return a deep copy of this object.
	 */
	public function copy() 
	{
		return new BinaryTreeNode(data) ;
	}
	
	/**
	 * Recursively calculates and returns the depth of a tree.
	 * @return The depth of the tree.
	 */
	public function getDepth( node:BinaryTreeNode ):Number
	{
		var nLeft:Number  = -1 ;
		var nRight:Number = -1 ;
		if (node == null) 
		{
			node = this ;
		}
		if (node.left)
		{
			nLeft = getDepth(node.left);
		}
		if (node.right)
		{
			nRight = getDepth(node.right);
		}
		return (Math.max(nLeft, nRight) + 1);
	}
	
	/**
	 * Returns {@code true} if this node is left of its parent.
	 * @return {@code true} if this node is left, otherwise false.
	 */
	public function isLeft():Boolean
	{
		return this == parent.left ;
	}
		
	/**
	 * Returns {@code true} if this node is right of its parent.
	 * @return {@code true} if this node is right, otherwise false.
	 */
	public function isRight():Boolean
	{
		return this == parent.right;
	}

	/**
	 * Recursively clears the tree by deleting all child nodes underneath the node the method is called on.
	 */
	public function reset():Void
	{
		if (left)
		{
			left.reset();
		}
		left = null;
		if (right)
		{
			right.reset();
		}
		right = null;
	}

	/**
	 * Sets data into the left child.
	 * @param data The data value into the left child.
	 */
	public function setLeft( data ):Void
	{
		if (!left)
		{
			left = new BinaryTreeNode(data);
			left.parent = this;
		}
		else
		{
			left.data = data;
		}
	}
		
	/**
	 * Sets data into the right child.
	 * @param data The data value into the right child.
	 */
	public function setRight( data ):Void
	{
		if (! right )
		{
			right = new BinaryTreeNode(data) ;
			right.parent = this ;
		}
		else
		{
			right.data = data ;
		}
	}
	
	/**
	 * Recursively counts the total number of nodes including this node.
	 * @return the total number of nodes including this node.
	 */
	public function size():Number
	{
		var c:Number = 1;
		if (left)
		{
			c += left.size();
		}
		if (right)
		{
			c += right.size();
		}
		return c ;
	}

	/**
	 * Returns a Eden reprensation of the object.
	 * @return a string representing the source code of the object.
	 */
	public function toSource(indent:Number, indentor:String):String 
	{
		return "new andromeda.data.tree.BinaryTreeNode(" + data + ")" ;
	}

	/**
	 * Returns the string representation of this instance.
	 * @return the string representation of this instance.
	 */
	public function toString():String 
	{
		return "[BinaryTreeNode data:" + data + "]" ;
	}

}