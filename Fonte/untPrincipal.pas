unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.DBCtrls, Vcl.Mask,
  ZAbstractRODataset, ZAbstractDataset, ZDataset, System.json, Vcl.WinXCtrls,
  uDWAbout, uRESTDWBase;

type
  TForm1 = class(TForm)
    PgcCliente: TPageControl;
    TshTabela: TTabSheet;
    TshInformacao: TTabSheet;
    DBGrid1: TDBGrid;
    PnlTopoCliente: TPanel;
    LblId: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    Label1: TLabel;
    Label2: TLabel;
    EdtCep: TDBEdit;
    Label3: TLabel;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    Label5: TLabel;
    DBEdit5: TDBEdit;
    Label6: TLabel;
    EdtNumero: TDBEdit;
    Label7: TLabel;
    DBEdit7: TDBEdit;
    Label8: TLabel;
    DBEdit8: TDBEdit;
    DBEdit9: TDBEdit;
    Label9: TLabel;
    GroupBox1: TGroupBox;
    DBGrid2: TDBGrid;
    Panel1: TPanel;
    DBNavigator2: TDBNavigator;
    PnlMenu: TPanel;
    DBNavigator1: TDBNavigator;
    DBComboBox1: TDBComboBox;
    DBEdit3: TDBEdit;
    Panel2: TPanel;
    Label10: TLabel;
    ToggleSwitch: TToggleSwitch;
    Label11: TLabel;
    Label12: TLabel;
    RESTServicePooler1: TRESTServicePooler;
    procedure FormActivate(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure PgcClienteChanging(Sender: TObject; var AllowChange: Boolean);
    procedure EdtCepExit(Sender: TObject);
    procedure ToggleSwitchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function CepValido: boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses dtmPrincipal, untServerRestDW;

function TForm1.CepValido: boolean;
var
  Cep: String;
begin
  Result := True;

  Cep := EdtCep.Text;
  Cep := Copy(Cep,1,5) + Copy(Cep,7,3);

  Result := (Length(Trim(Cep)) > 0);
  if Result then
    if (StrToInt(Cep) <= 1000000.0) then
    begin
      Application.MessageBox(PChar('CEP tem que ser maior que [01000-000]'),'Aten��o',MB_ICONEXCLAMATION);
      Result:=False;
    end;
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
begin
  if not PrincipalM.QryCliente.IsEmpty then
    PgcCliente.ActivePage := TshInformacao;
end;

procedure TForm1.EdtCepExit(Sender: TObject);
var
  Result: String;
  teste: TJSONObject;
begin
  if (PrincipalM.QryCliente.State in [dsInsert,dsEdit]) and
     (Application.MessageBox('Deseja buscar informa��es online do CEP?','Quest�o',MB_ICONQUESTION+MB_YESNO)=mrYes) then
  begin
    if CepValido then
      Result:=PrincipalM.GetCepJson(EdtCep.Text);
    if Result<>'' then
    begin
      EdtCep.SetFocus;
      Application.MessageBox(Pchar('CEP INV�LIDO'+#13+Result),'Aten��o',MB_ICONERROR);
    end
    else
      EdtNumero.SetFocus;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if not PrincipalM.Connected then
  begin
    Application.MessageBox(Pchar('N�o foi poss�vel se conectar a base. Verifique o Data Modulo'),'Aten��o',MB_ICONERROR);
    Application.Terminate;
  end;

  PgcCliente.ActivePageIndex := 0;

  PrincipalM.QryCliente.Open;
  PrincipalM.QryContato.Open;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  RESTServicePooler1.ServerMethodClass := TdtmServerRestDW;
end;

procedure TForm1.PgcClienteChanging(Sender: TObject; var AllowChange: Boolean);
begin
  if PgcCliente.ActivePage=TshInformacao then
    if (PrincipalM.QryCliente.State in [dsInsert,dsEdit]) or
       (PrincipalM.QryContato.State in [dsInsert,dsEdit]) then
    begin
       Application.MessageBox(PChar('Finalize As Altera��es'),'Aten��o',MB_ICONQUESTION);
       AllowChange := False;
    end;
end;

procedure TForm1.ToggleSwitchClick(Sender: TObject);
begin
  RESTServicePooler1.Active := (ToggleSwitch.State=tssOn);
  label11.Visible := (ToggleSwitch.State=tssOn);
  Label12.Visible := (ToggleSwitch.State=tssOn);
end;

end.
