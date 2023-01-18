/****************************************************************************
*
*			1---------------------------------------------------------l
*		   |	 Wersling		O	o	O O O O O O     	00   	   |
*			l------------------------------------------------|--------l
*															S S	
*														   S	S
*						/○\ ●								S S
*						/■\/■\							 v
*			   	 ╪═╪  <|　||								 |
*
*****************************************************************************
*
* @author
* @version
*/
interface net.manaca.media.IPlayer
{
	public function play () : Void;
	public function pause () : Void;
	public function stop () : Void;
	public function playPosition (n : Number) : Void;
}
