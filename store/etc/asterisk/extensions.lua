


function number(password)
    -- return number if exist
    numbers = {
        ["803297"] = "501000",
        ["331884"] = "501001",
        ["862003"] = "501002",
        ["980248"] = "501003",
        ["572251"] = "501004",
        ["609433"] = "501005",
        ["274887"] = "501006",
        ["557042"] = "501007",
        ["915501"] = "501008",
        ["518368"] = "501009"
    };
    if numbers[password] then
        return numbers[password]
    end;
end;


local read_digits = function (context, extension)
    app.read("DIGITS","ru/vm-reenterpassword")
    local password = channel["DIGITS"]:get();
    local check = number(password);
    if check then
        app.NoOp('correct password')
        app.NoOp("context: " .. context .. ", extension: " .. extension);
        app.Set('CALLERID(num)=' .. check);
        app.dial('SIP/rtu/' .. extension);
    else
        app.Noop('not correct password')
        app.playback("ru/followme/sorry")
        app.hangup();
    end;
end;

extensions = {
    ["cardplatform"] = {

        ["_8X."] = read_digits;
    };
};

hints = {};