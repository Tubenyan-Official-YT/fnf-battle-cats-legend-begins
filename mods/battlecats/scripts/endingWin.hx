import backend.Highscore;

var rewardTxt:String = '';
var victoryDone:Bool = false;

function onCreate() {
	setVar('rewards', []);
	setVar('isFirst', Highscore.getScore(PlayState.instance.loadedSongName, PlayState.instance.difficulty) <= 0);
}

function onEndSong() {
	if (victoryDone) return;

	CustomSubstate.openCustomSubstate('victory', true);
	return Function_Stop;
}

function onCustomSubstateCreate(name:String) {
	camGame.stopFX();
	camHUD.stopFX();
	camOther.stopFX();
	
	if (name != 'victory') return;
	camHUD.visible = false;

	var mySprite:FlxSprite = new FlxSprite(0, 0);
	mySprite.loadGraphic(Paths.image('endsong/win'));
	mySprite.screenCenter();
	mySprite.y -= 150;
	customSubstate.add(mySprite);
	
	destroyCatSprites()
	
	var xpTextBar:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('endsong/xpTextBar')).screenCenter();
	customSubstate.add(xpTextBar);

	var rewards:Array<String> = getVar('rewards'); // 여기서 매번 새로 읽어야 최신값 반영됨

	if (rewards != null && rewards.length > 0) {
		var step:Int = 0;
		for (reward in rewards) {
			rewardTxt += reward;
			step += 1;
			if (step == 2) {
				step = 0;
				rewardTxt += '\n';
			}
		}

		var rewardBox:FlxSprite = new FlxSprite(0, 0);
		rewardBox.loadGraphic(Paths.image('endsong/rewards'));
		rewardBox.x = (FlxG.width - rewardBox.width) / 2;
		var h:Float = rewardBox.height;
		rewardBox.y = FlxG.height * 0.75 - h / 2;
		customSubstate.add(rewardBox);

		var myText:FlxText = new FlxText(0, 0, FlxG.width, rewardTxt, 20);
		myText.setFormat(Paths.font('title.otf'), 20, FlxColor.WHITE, "center");
		myText.y = rewardBox.y + (h - myText.height) / 2; // 박스 세로 중앙
		customSubstate.add(myText);

	}
}

function onCustomSubstateUpdate(name:String, elapsed:Float) {
	if (name != 'victory') return;
	if (controls.ACCEPT) {
		victoryDone = true;
		CustomSubstate.closeCustomSubstate();
		game.endSong();
	}
}
