


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

local read_password = function (context, extension)
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

function check_login_password(login, password)
    -- body
    numbers = {
        ["501000"] = "803297",
        ["501001"] = "331884",
        ["501002"] = "862003",
        ["501003"] = "980248",
        ["501004"] = "572251",
        ["501005"] = "609433",
        ["501006"] = "274887",
        ["501007"] = "557042",
        ["501008"] = "915501",
        ["501009"] = "518368",
    };
    if (numbers[login] == password) then
        return true
    end;
end;

local read_number_password = function (context, extension)
    app.read("login","/var/menu/vm-enter-num-to-call")
    local login = channel["login"]:get();
    app.read("password","ru/vm-reenterpassword")
    local password = channel["password"]:get();
    local check = check_login_password(login, password)
    if check then
        app.NoOp('correct login/password')
        app.NoOp("context: " .. context .. ", extension: " .. extension);
        app.Set('CALLERID(num)=' .. login);
        app.dial('SIP/rtu/' .. extension);
    else
        app.NoOp("not correct login or password")
        app.playback("ru/followme/sorry")
        app.hangup();
    end;
    -- body
end;


extensions = {
    ["cardplatform"] = {

        ["_8X."] = read_number_password;
        ["_7X."] = read_number_password;
    };
};

hints = {};