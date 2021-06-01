program CRUD;

uses
  Vcl.Forms,
  untPrincipal in 'untPrincipal.pas' {Form1},
  dtmPrincipal in 'dtmPrincipal.pas' {PrincipalM: TDataModule},
  Vcl.Themes,
  Vcl.Styles,
  untServerRestDW in 'untServerRestDW.pas' {dtmServerRestDW: TDataModule},
  untCliente in 'untCliente.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Cyan Dusk');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPrincipalM, PrincipalM);
  Application.CreateForm(TdtmServerRestDW, dtmServerRestDW);
  Application.Run;
end.
