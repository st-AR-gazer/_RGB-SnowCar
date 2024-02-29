enum EHueType
{
    CarSpeed,
    RGB,
    FixedColor
}

uint16 snowCarOffset = 0;

// STOLEN from https://github.com/ezio416/tm-current-effects/blob/465faccb580b4883eb0ec5502885dc0f2b2dfb1f/src/Effects.as#L247
int GetSnowCar(CSceneVehicleVisState@ State) {

    if (snowCarOffset == 0) {
        const Reflection::MwClassInfo@ type = Reflection::GetType("CSceneVehicleVisState");

        if (type is null) {
            error("Unable to find reflection info for CSceneVehicleVisState!");
            return 0;
        }

        snowCarOffset = type.GetMember("InputSteer").Offset - 8;
    }

    return Dev::GetOffsetUint8(State, snowCarOffset);
}

void Main()
{
    while (true)
    {
        if (S_Speed < 0) S_Speed = 0.01;
        try 
        {
            CSmPlayer@ player = VehicleState::GetViewingPlayer();
            auto state = VehicleState::GetVis(GetApp().GameScene, player).AsyncState;
            int speed = Math::Abs(int(state.FrontSpeed * 3.6f));

            if ((GetSnowCar(state) == 1) or S_Stupidity)
            {
                if (S_HueType == EHueType::RGB)
                {
                    if (player.LinearHue >= 0.999)
                    {
                        player.LinearHue = 0;
                    }
                    else
                    {
                        player.LinearHue += S_Speed / 100.0;
                    }
                } else if (S_HueType == EHueType::CarSpeed)
                {
                    player.LinearHue = speed / 1000.0;
                } else
                {
                    player.LinearHue = S_Hue;
                }
            }
            
            yield();
        } catch
        {
            yield();
            continue;
        }
    }
}