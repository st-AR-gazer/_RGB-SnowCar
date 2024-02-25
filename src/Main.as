[Setting name="Linear Hue Speed" max="0.05" min="0.0001" category="General"]
float LinearHueSpeed = 0.001;

[Setting name="Linear Hue Reset" category="General"]
bool LinearHueReset = false;

[Setting name="Set to gray" category="General"]
bool SetToGray = false;

void Main() {
    while (true) {
        CheckResetHue();

        CTrackMania@ app = cast<CTrackMania>(GetApp());
        if (app is null) return;

        auto playground = cast<CSmArenaClient>(app.CurrentPlayground);
        if (playground is null || playground.Arena.Players.Length == 0) return; 

        auto player = cast<CSmPlayer>(playground.Arena.Players[0]);
        if (player is null) return;

        // auto player = cast<CSmPlayer>(cast<CGameCtnPlayground>(app.CurrentPlayground).Players[0]);

        if (SetToGray) {
            player.LinearHue = -1;
            yield();
            return;
        }


        if (player.LinearHue >= 0.999) {
            player.LinearHue = 0;
        } else {
            player.LinearHue += LinearHueSpeed;
        }

        yield();
    }
}

void CheckResetHue() {
    if (LinearHueReset) {
        LinearHueSpeed = 0.001;
        LinearHueReset = false;
    }
}