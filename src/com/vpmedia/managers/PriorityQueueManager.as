class com.vpmedia.PriorityQueueManager
{
	private var _heap:Array;
	private var _map:Object;
	private var _idInc:Number;
	// constructor
	function PriorityQueueManager ()
	{
		init ();
	}
	// initialize
	function init ()
	{
		_heap = [];
		_map = {};
		_idInc = 0;
	}
	// insert items into the queue
	public function insert (obj, priority:Number):Number
	{
		if (priority == null)
		{
			priority = Number.MAX_VALUE;
		}
		var pos:Number = _heap.length;
		var id = _idInc++;
		var temp:Object = {priority:priority, data:obj, id:id, pos:pos};
		_map[id] = temp;
		_heap[pos] = temp;
		_filterUp (pos);
		return id;
	}
	// get the value of the top priority w/o removing it
	public function getTop ()
	{
		return _heap[0].priority;
	}
	// remove, and return, the top element in the heap
	public function removeTop ()
	{
		if (_heap.length == 0)
		{
			return false;
		}
		var result = _heap[0].data;
		delete _map[_heap[0].id];
		delete _heap[0];
		_heap[0] = _heap[_heap.length - 1];
		_heap[0].pos = 0;
		_heap.splice (_heap.length - 1, 1);
		_filterDown (0);
		return result;
	}
	// reprioritize an element
	public function setPriority (id:Number, value:Number)
	{
		var element = _map[id];
		var pos = element.pos;
		var oldPriority = element.priority;
		element.priority = value;
		if (oldPriority > element.priority)
		{
			_filterUp (pos);
		}
		else
		{
			_filterDown (pos);
		}
	}
	// return the priority of an element
	public function getPriority (id:Number):Number
	{
		return _map[id].priority;
	}
	// determine if the queue is empty
	public function isEmpty ():Boolean
	{
		return _heap.length == 0;
	}
	// get priority of top element
	public function getTopPriority ():Number
	{
		return _heap[0].priority;
	}
	// check to see if an ID is in the queue
	public function isQueued (id:Number):Boolean
	{
		return _map[id] != null;
	}
	// remove an object from the queue
	public function remove (id:Number):Boolean
	{
		if (!isQueued (id))
		{
			return false;
		}
		var index = _map[id].pos;
		delete _map[id];
		delete _heap[index];
		_heap[index] = _heap[_heap.length - 1];
		_heap[0].pos = 0;
		_heap.splice (_heap.length - 1, 1);
		return true;
	}
	//-----------------------------------------------------------
	// Private "helper" methods
	//-----------------------------------------------------------
	private function _filterUp (index:Number):Void
	{
		var i = index;
		while (i > 0 && _heap[int ((i - 1) / 2)].priority > _heap[i].priority)
		{
			var parent = Math.floor ((i - 1) / 2);
			var temp = _heap[i];
			_heap[i] = _heap[parent];
			_heap[parent] = temp;
			_heap[i].pos = i;
			_heap[parent].pos = parent;
			i = parent;
		}
	}
	private function _filterDown (index:Number):Void
	{
		var i = index;
		var left, right, k;
		if (i < (_heap.length - 1) / 2)
		{
			left = 2 * i + 1;
			right = 2 * i + 2;
			if (right >= _heap.length)
			{
				k = left;
				right = left;
			}
			else
			{
				if (_heap[left].priority < _heap[right].priority)
				{
					k = left;
				}
				else
				{
					if (_heap[left].priority == _heap[right].priority)
					{
						if (_heap[left].id < _heap[right].id)
						{
							k = left;
						}
						else
						{
							k = right;
						}
					}
					else
					{
						k = right;
					}
				}
			}
			if (_heap[i].priority > _heap[k].priority)
			{
				var temp = _heap[i];
				_heap[i] = _heap[k];
				_heap[k] = temp;
				_heap[i].pos = i;
				_heap[k].pos = k;
				_filterDown (k);
			}
			else
			{
				if (_heap[i].priority == _heap[k].priority)
				{
					if (_heap[i].id > _heap[k].id)
					{
						var temp = _heap[i];
						_heap[i] = _heap[k];
						_heap[k] = temp;
						_heap[i].pos = i;
						_heap[k].pos = k;
						_filterDown (k);
					}
				}
			}
		}
	}
}
/* Usage :-
queue = new PriorityQueue();
for (var i = 0; i<5; ++i) {
var p = random(100);
var obj = new Object();
obj.message = "Item "+i+", priority "+p;
trace("Enqueue: "+obj.message);
id = queue.insert(obj, p);
}
trace("---------------------------");
for (var i = 0; i<5; ++i) {
obj = queue.removeTop();
trace("Dequeue: "+obj.message);
}
//trace output
Enqueue: Item 0, priority 13
Enqueue: Item 1, priority 13
Enqueue: Item 2, priority 18
Enqueue: Item 3, priority 30
Enqueue: Item 4, priority 98
---------------------------
Dequeue: Item 0, priority 13
Dequeue: Item 1, priority 13
Dequeue: Item 2, priority 18
Dequeue: Item 3, priority 30
Dequeue: Item 4, priority 98
*/
