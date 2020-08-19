session:sleep(500)
session:execute("playback", "welcome.wav");

conf = session:playAndGetDigits(6, 9, 3, 8000, "#", "conference.wav", "error.wav", "\\d+", "digits_received", 1000, "hangup");
session:execute("playback", "thanks.wav");

pin = session:playAndGetDigits(5, 5, 3, 8000, "#", "pin.wav", "error.wav", "\\d+", "digits_received", 1000, "hangup");
session:execute("playback", "thanks.wav");

api = freeswitch.API();
api:execute("log", conf);
api:execute("log", pin);

confid = api:execute("curl", "https://example.com/check_pin.php?id=" .. conf .. "&pin=" .. pin);

if(confid == "500") then
    session:sleep(500)
    session:execute("playback", "wrongcreds.wav");

    conf = session:playAndGetDigits(6, 9, 3, 8000, "#", "conference.wav", "error.wav", "\\d+", "digits_received", 1000, "hangup");
    session:execute("playback", "thanks.wav");

    pin = session:playAndGetDigits(5, 5, 3, 8000, "#", "pin.wav", "error.wav", "\\d+", "digits_received", 1000, "hangup");
    session:execute("playback", "thanks.wav");

    confid = api:execute("curl", "https://example.com/check_pin.php?id=" .. conf .. "&pin=" .. pin);

    if(confid == "500") then
        session:sleep(500)
        session:execute("playback", "wrongcreds.wav");

        conf = session:playAndGetDigits(6, 9, 3, 8000, "#", "conference.wav", "error.wav", "\\d+", "digits_received", 1000,
        "hangup");
        session:execute("playback", "thanks.wav");

        pin = session:playAndGetDigits(5, 5, 3, 8000, "#", "pin.wav", "error.wav", "\\d+", "digits_received", 1000,
        "hangup");
        session:execute("playback", "thanks.wav");

        confid = api:execute("curl", "https://example.com/check_pin.php?id=" .. conf .. "&pin=" .. pin);
    else
        session:hangup();
    end
else
    api:execute("log", confid);
    session:execute("set_profile_var", "Veedeo-Conf-ID=" .. confid);
    session:execute("set_profile_var", "Veedeo-ID=" .. conf);
    session:execute("set_profile_var", "Veedeo-PIN=" .. pin);
    session:execute("set_profile_var", "Veedeo-Dialin=true");
    session:execute("conference", confid .. "@default");
    api:execute("log", "Last statement reached");
    session:hangup();
end