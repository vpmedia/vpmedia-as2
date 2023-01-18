import de.popforge.engine.w3d.Projection;
import de.popforge.engine.w3d.TriPoly;

interface de.popforge.engine.w3d.Renderer
{
	public function dispose(): Void;
	public function clear(): Void;
	public function renderTriPoly( triPoly: TriPoly, p: Projection ): Void;
}