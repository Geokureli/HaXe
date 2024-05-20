package greed.states {
	import krakel.KrkState;
	import krakel.xml.dame.DameParser;
	
	/**
	 * ...
	 * @author George
	 */
	public class ParserState extends KrkState {
		
		override public function create():void {
			super.create();
			
			new Parser();
		}
	}
}
import krakel.xml.dame.DameParser;

class Parser extends DameParser {
	
	[Embed(source = "../../../res/greed/project.dam", mimeType = "application/octet-stream")] static private const GAME_DATA:Class;
	
	public function Parser() {
		super(new XML(new GAME_DATA()));
	}
}