import backend.Highscore;

var rewardTxt:String = '';
var victoryDone:Bool = false;

function onCreate() {
	setVar('rewards', []);

	// PlayState.SONG.song과 PlayState.storyDifficulty를 활용하여 정확한 점수 데이터 참조
	var songName:String = PlayState.SONG.song;
	var diff:Int = PlayState.storyDifficulty;

	setVar('isFirst', Highscore.getScore(songName, diff) <= 0);
}

function onEndSong() {
	if (victoryDone) return;

	var isFirstClear:Bool = getVar("isFirst");
	if (isFirstClear) {
		var rewards:Array<String> = getVar('rewards');
		if (difficultyName == "chapter3") {
			addLS(2);
			rewards.push("LeaderShip + 2");
		} else {
			addLS(1);
			rewards.push("LeaderShip + 1");
		}
		setVar('rewards', rewards);
		setVar('isFirst', false); // 보상 지급 후 상태 업데이트
	}

	CustomSubstate.openCustomSubstate('victory', true);
	return Function_Stop;
}

function onCustomSubstateCreate(name:String) {
	camGame.stopFX();
	camHUD.stopFX();
	camOther.stopFX();
	
	if (name != 'victory') return;
	camHUD.visible = false;

	rewardTxt = '';

	var mySprite:FlxSprite = new FlxSprite(0, 0);
	mySprite.loadGraphic(Paths.image('endsong/win'));
	mySprite.screenCenter();
	mySprite.y -= 150;
	customSubstate.add(mySprite);
	
	var xpTextBar:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('endsong/xpTextBar')).screenCenter();
	customSubstate.add(xpTextBar);

	var rewards:Array<String> = getVar('rewards');

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
		myText.y = rewardBox.y + (h - myText.height) / 2;
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