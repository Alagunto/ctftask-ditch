unit Utility;

uses System.Net.Sockets;

function prepare(s: string): array of byte;
var data: array of byte;
begin
    setLength(data, length(s));

    for var i := 0 to length(s) - 1 do
        data[i] := ord(s[i + 1]);
    prepare := data;
end;

function prepare(data: array of byte): string;
var s: string;
begin
  s := ''; 
  for var i := 0 to data.length - 1 do begin
    if(data[i] = 0) then 
      break;
    s := s + chr(data[i]);
  end;

  prepare := s;
end;

function sreceive(socket: System.Net.Sockets.Socket; buffer: integer): string;
var data: array of byte;
begin
  setlength(data, buffer);
  
  var how_much := socket.receive(data);
  setLength(data, how_much);

  sreceive := prepare(data);
end;

end.
