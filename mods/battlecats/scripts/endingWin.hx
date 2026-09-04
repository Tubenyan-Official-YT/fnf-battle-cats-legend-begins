setVar('rewards', []);
var rewards:Array<String> = getVar('rewards');
var rewardTxt:String = '';
var victoryDone:Bool = false;

function onEndSong() {
	if (victoryDone) return;

	CustomSubstate.openCustomSubstate('victory', true);
	return Function_Stop;
}

function onCustomSubstateCreate(name:String) {
	if (name != 'victory') return;

	var mySprite:FlxSprite = new FlxSprite(0, 0);
	mySprite.loadGraphic(Paths.image('endsong/win'));
	mySprite.screenCenter(); // 완전승리
	mySprite.y -= 100;
	customSubstate.add(mySprite);


	if (rewards.length > 0) {
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
		rewardBox.screenCenter(X);
		var h:Float = rewardBox.height;
		rewardBox.y = FlxG.height * 0.75 - h / 2;
		customSubstate.add(rewardBox);

		var myText:FlxText = new FlxText(0, 300, 600, rewardTxt, 20);
		myText.setFormat(Paths.font('title.otf'), 20, FlxColor.WHITE, CENTER);
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
