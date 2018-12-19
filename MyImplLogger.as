package  {
	import net.nend.adobeair.ILogger;

	public class MyImplLogger implements ILogger {

		public function MyImplLogger() {
			// constructor code
		}

		public function output(message:String, level:int):void {
			trace("[nend-AdobeAir-Sample-MyImplLogger] level = " + level + ": " + message);
		}
	}
	
}
