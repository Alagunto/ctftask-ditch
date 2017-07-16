uses System;
uses System.Net;
uses System.Net.Sockets;
uses Timers;
uses Utility;
uses App;

var server, handler: System.Net.Sockets.Socket;
    s: string;
    handlers: array of System.Net.Sockets.Socket;
    timers: array of Timer;

procedure processUser(timer_id, user_id: integer);
begin
  timers[timer_id].Stop();

  writeln('user ', user_id, ' is connected');

  while(true) do begin
    // Receive message, process, answer, repeat
    var message: string := '';

		while(true) do begin
			if(
				(length(message) > 0) and (
					(message[length(message)] = chr(10)) or
					(message[length(message)] = chr(13))
				)
			) then 
				break;

			if(not handlers[user_id].Connected) then
				break;

			message := message + sreceive(handlers[user_id], 1024);
		end;

    if(length(message) = 0) then
      continue;

		var answer: string := App.process(message.Trim);

    if(not handlers[user_id].Connected) then begin
      break;
    end;
    handlers[user_id].send(prepare(answer + chr(10)));
  end;
end;

begin
  server := new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
  server.bind(new IPEndPoint(IPAddress.Parse('0.0.0.0'), 4120));
  server.listen(100);
	WriteLn('Bound to the port 4120. Ready!');

  setLength(handlers, 0);
  setLength(timers, 0);

  while(true) do
  begin
    handler := server.accept();

    setLength(handlers, handlers.Length + 1); 
    setLength(timers, timers.Length + 1); 

    var user_id: integer := handlers.Length - 1; 
    var timer_id: integer := timers.Length - 1; 

    handlers[user_id] := handler; 

    // Now, start a timer-thread for this handler

    var processUserWrapper: () -> () := () -> processUser(timer_id, user_id);
    var t: Timer := new Timer(1, processUserWrapper);
    timers[timer_id] := t;
    t.Start();
  end;
end.
