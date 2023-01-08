program Hello;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson, // It's necessary to use the unit
  System.JSON,
  system.SysUtils;

begin
  // It's necessary to add the middleware in the Horse:
  THorse.Use(Jhonson());

  // You can specify the charset when adding middleware to the Horse:
  // THorse.Use(Jhonson('UTF-8'));

  THorse.Get('/ping',
  procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
      LBody: TJSONObject;
  begin
      // Req.Body gives access to the content of the request in string format.
      // Using jhonson middleware, we can get the content of the request in JSON format.

      LBody := Req.Body<TJSONObject>;
      Res.Send<TJSONObject>(LBody);
  end);

  THorse.Get('/clientes',
  procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  var
      Clientes: TJSONArray;

  begin
    Clientes := TJsonArray.Create;
    Clientes.Add(TJsonObject.Create(TJsonPair.Create('Name: ','Jes�s C�rdova')));

    try
      Res.Send<TJSONArray>(Clientes);
    except on E: Exception do
      Res.Send(TJsonObject.Create.AddPair('Mensaje: ', E.Message))
    end;
  end);

  THorse.Listen(9000, procedure (Horse: THorse)
  begin
    writeln('Server listening on port 9000');
  end);

end.
