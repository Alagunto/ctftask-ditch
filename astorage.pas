unit AStorage;
uses Timers;
uses System;
uses System.IO;
uses System.Linq;

var storage: string;
    storage_path: string := 'database.dmp';
		hashset_storage: string;
		hashset_storage_path: string := 'database.hashsets.dmp';

		t: Timer;

procedure save();
begin
	System.IO.File.WriteAllText(storage_path, storage);
	System.IO.File.WriteAllText(hashset_storage_path, hashset_storage);
	WriteLn('Stored ', length(storage) + length(hashset_storage), ' bytes to storages');
end;

function hsetexists(set_name: string): boolean;
begin
  result := hashset_storage.split(',').Contains(set_name);
end;

function hcreateset(set_name: string): string;
begin
	  if(not hsetexists(set_name)) then begin
			if(length(hashset_storage) = 0) then
				hashset_storage := set_name
			else
				hashset_storage := hashset_storage + ',' + set_name;
			result := '::> OK';
		end else begin
			result := '::> ALREADY_EXISTS';
		end;
end;

function hset(set_name, key, value: string): string;
begin
	if(not hsetexists(set_name)) then begin
		result := '::> Set doesn''t exist';
		exit();
	end;

	if(length(storage) = 0) then
		storage := set_name + ':' + key + ':' + value
  else
		storage := storage + ',' + set_name + ':' + key + ':' + value;

	result := '::> OK';
end;

function hget(set_name, key: string): string;
begin
	if(not hsetexists(set_name)) then begin
		result := '::> Set doesn''t exist';
		exit();
	end;

	var found := false;
	var answer := '';

	foreach var row in storage.split(',') do begin
    var columns := row.split(':');
		if (length(columns) <> 3) then
			continue;
		
		if ((columns[0] = set_name) and (columns[1] = key)) then begin
			answer := columns[2];
			found := true;
		end;
	end;

	if(not found) then
		result := '::> Not found'
	else
		result := answer;
end;

function hgetall(set_name: string): string;
begin
	if(not hsetexists(set_name)) then begin
		result := '::> Set doesn''t exist';
		exit();
	end;

	var answer := '';
	
	foreach var row in storage.split(',') do begin
    var columns := row.split(':');
		if (length(columns) <> 3) then
			continue;
		
		if (columns[0] = set_name) then begin
			answer := answer + columns[1] + '=' + columns[2] + chr(10);
		end;
	end;

	result := answer;
end;

procedure flushall();
begin
  hashset_storage := '';
	storage := '';
end;

begin
	if (System.IO.File.Exists(storage_path)) then begin
    storage := System.IO.File.ReadAllText(storage_path);
		WriteLn('Restored ', length(storage), ' bytes from storage'); 
	end;
	if (System.IO.File.Exists(hashset_storage_path)) then begin
    hashset_storage := System.IO.File.ReadAllText(hashset_storage_path);
		WriteLn('Restored ', length(hashset_storage), ' bytes from hashset storage'); 
	end;

	t := new Timer(15000, save);
	t.Start();
end.
