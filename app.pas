unit App;
uses AStorage;

var ADMIN_KEY: string := 'REMEMBER_TO_CHANGE_THIS_LATER';

function get(p: Array of string): string; Forward;
function _set(p: Array of string): string; Forward;
function hget(p: Array of string): string; Forward;
function hset(p: Array of string): string; Forward;
function hgetall(p: Array of string): string; Forward;
function hcreateset(p: Array of string): string; Forward;
function hsetexists(p: Array of string): string; Forward;
function flushall(p: Array of string): string; Forward;
function help(p: Array of string): string; Forward;

function process(message: string): string;
begin
	WriteLn('::> ', message);
	var tokens: Array of string := message.Split();

	if(length(tokens) = 0) then begin
		result := 'Bad command';
	end else begin
		var command: string := tokens[0];
		if(command = 'GET') then begin
			result := get(tokens.Skip(1).toArray());
		end else
		if(command = 'SET') then begin
			result := _set(tokens.Skip(1).toArray());
		end else
		if(command = 'HGET') then begin
			result := hget(tokens.Skip(1).toArray());
		end else
		if(command = 'HSET') then begin
			result := hset(tokens.Skip(1).toArray());
		end else
		if(command = 'HELP') then begin
			result := help(tokens.Skip(1).toArray());
		end else
		if(command = 'HGETALL') then begin
			result := hgetall(tokens.Skip(1).toArray());
		end else
		if(command = 'DEBUG_GETSTORAGE') then begin
			result := AStorage.storage;
		end else
		if(command = 'HCREATESET') then begin
			result := hcreateset(tokens.Skip(1).toArray());
		end else
		if(command = 'HSETEXISTS') then begin
			result := hsetexists(tokens.Skip(1).toArray());
		end else
		if(command = 'FLUSHALL') then begin
			result := flushall(tokens.Skip(1).toArray());
		end else
		begin
			result := 'Command not found. Use HELP.'
		end;
	end;
end;

function hcreateset(p: Array of string): string;
begin
  if (length(p) <> 1) then begin
		result := 'Bad syntax for hcreateset command. This command creates a new set. Use like: HCREATESET setname.';
	end else 
	begin
		result := AStorage.hcreateset(p[0]);
	end;
end;

function hsetexists(p: Array of string): string;
begin
  if (length (p) <> 1) then begin
		result := 'Bad syntax for hsetexists command. This command checks if there is a set with that name. Use like: HSETEXISTS setname.';
	end else
	begin
		if(AStorage.hsetexists(p[0])) then
			result := 'YES'
		else
			result := 'NO';
	end;
end;

function get(p: Array of string): string;
begin
	if (length(p) <> 1) then begin
		result := 'Bad syntax for get command. Use like: GET key';
	end
	else begin
		result := AStorage.hget('', p[0]);
	end;
end;

function _set(p: Array of string): string;
begin
  if (length(p) <> 2) then begin
		result := 'Bad syntax for set command. Use like: SET key value';
	end
	else begin
  	result := AStorage.hset('', p[0], p[1]);
	end;
end;

function hget(p: Array of string): string;
begin
  if (length(p) <> 2) then begin
		result := 'Bad syntax for hget command. Use like: HGET set_name key';
	end
	else begin
		result := AStorage.hget(p[0], p[1]);
	end;
end;

function hset(p: Array of string): string;
begin
	if (length(p) <> 3) then begin
		result := 'Bad syntax for hset command. Use like: HSET set_name key value';
	end 
	else begin
		result := AStorage.hset(p[0], p[1], p[2]);
	end;
end;

function hgetall(p: Array of string): string;
begin
	if (length(p) > 1) then begin
		result := 'Bad syntax for hgetall command. Use like: HGETALL set_name';
	end else 
	begin
		var name := '';
		if(length(p) = 1) then
			name := p[0];
		result := AStorage.hgetall(name);
	end;
end;

function flushall(p: Array of string): string;
begin
	if (length(p) <> 1) then begin
    result := 'Bad syntax for flushall command. Use like: FLUSHALL secret_key, where secret_key is admin secret key.';
	end else begin
    if(p[0] <> ADMIN_KEY) then begin
			result := 'Wrong admin key!';
		end
		else begin
			AStorage.flushall();
			result := 'Flushed!';
		end;
	end;
end;

function help(p: Array of string): string;
begin
	if (length(p) = 0) then	begin
		result := 'Actions: SET GET HGET HSET HGETALL HCREATESET HSETEXISTS'
	end;
end;

begin

end.
