program CRUD;

uses
  Vcl.Forms,
  Vcl.Themes,
  Vcl.Styles,
  PrincipalF in 'PrincipalF.pas' {frmPrincipal},
  PrincipalM in 'PrincipalM.pas' {dtmPrincipal: TDataModule},
  ServerRestDWM in 'ServerRestDWM.pas' {dtmServerRestDW: TDataModule},
  ClienteC in 'ClienteC.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Cyan Dusk');
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TdtmPrincipal, dtmPrincipal);
  Application.CreateForm(TdtmServerRestDW, dtmServerRestDW);
  Application.Run;
end.
