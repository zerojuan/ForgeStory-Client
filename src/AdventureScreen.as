package
{
	import com.adobe.serialization.json.JSON;
	import com.pblabs.screens.BaseScreen;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import com.forgestory.rpg.Avatar;
	import com.forgestory.rpg.ItemDataObject;
	import com.forgestory.rpg.PlayerData;
	
	public class AdventureScreen extends BaseScreen
	{
		private var monster:ItemDataObject;
		
		private var avatar:Avatar;
		
		public function AdventureScreen()
		{
			super();
			
			monster = new ItemDataObject();
			
			avatar = PlayerData.instance.avatar;
		}
		
		override public function onShow():void{
			if(DangerItems.monster){
				monster = DangerItems.monster;
				DangerItems.monster = null;
				startMonsterFight();
			}else{
				getMonster();
			}
		}
		
		private function getMonster():void{
			var urlVariables:URLVariables = new URLVariables();
			urlVariables.uid = PlayerData.instance.player.uid;
			
			var urlRequest:URLRequest = new URLRequest("getPlayerItems.php");
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = urlVariables;
			
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.addEventListener(Event.COMPLETE, onMonsterLoaded);
			urlLoader.load(urlRequest);
		}
		
		private function onMonsterLoaded(evt:Event):void{
			var obj:Object = JSON.decode(evt.target.data);
			monster.populate(obj);
			startMonsterFight();
		}
		
		private function startMonsterFight():void{
			
		}
	}
}