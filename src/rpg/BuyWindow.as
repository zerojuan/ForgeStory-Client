package rpg
{
	import com.bit101.components.Window;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import model.Item;
	
	public class BuyWindow extends Window{
		private var buyWindowPanel:BuyWindowPanel;
		
		public function BuyWindow(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Window")
		{
			super(parent, xpos, ypos, title);
			hasCloseButton = true;
			width = 250;
			height = 120;
			addEventListener(Event.CLOSE, onCloseBuyWindow);
			visible = false;
			
			buyWindowPanel = new BuyWindowPanel();
			
			content.addChild(buyWindowPanel);
		}
		
		public function enable(val:Boolean):void{
			visible = val;
		}
		
		public function setBuyAndCancelCallBacks(buyCallBack:Function, cancelCallBack:Function):void{
			buyWindowPanel.buyCallback = buyCallBack;
			buyWindowPanel.cancelCallback = cancelCallBack;
		}
		
		public function setItem(item:Item):void{
			buyWindowPanel.setSummary(item);
		}
		
		public function isSpecial(item:Item):void{
			buyWindowPanel.setFreeSummary(item);
		}
		
		private function onCloseBuyWindow(evt:Event):void{
			visible = false;
			dispatchEvent(evt);
		}
	}
}