unit dtmPrincipal;

interface

uses
  System.SysUtils, System.Classes, Vcl.Forms, Vcl.Dialogs, ZAbstractConnection, ZConnection,
  Data.DB, ZAbstractRODataset, ZAbstractDataset, ZDataset, ZSqlUpdate,
  REST.Types, Data.Bind.Components, Data.Bind.ObjectScope, REST.Client,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, System.json,
  uDWAbout, uRESTDWBase;

type
  TPrincipalM = class(TDataModule)
    connPrincipal: TZConnection;
    QryCliente: TZQuery;
    DtsCliente: TDataSource;
    DtsContato: TDataSource;
    QryContato: TZQuery;
    QryClienteID: TIntegerField;
    QryClienteNOME: TWideStringField;
    QryClienteCEP: TWideStringField;
    QryClienteLOGRADOURO: TWideStringField;
    QryClienteNUMERO: TWideStringField;
    QryClienteCOMPLEMENTO: TWideStringField;
    QryClienteCIDADE: TWideStringField;
    QryClienteIBGE_CIDADE: TWideStringField;
    QryClienteSIGLA_UF: TWideStringField;
    QryClienteIBGE_UF: TWideStringField;
    QryContatoID: TIntegerField;
    QryContatoNOME: TWideStringField;
    QryContatoDATA_NASC: TDateTimeField;
    QryContatoIDADE: TIntegerField;
    QryContatoTELEFONE: TWideStringField;
    QryContatoID_CLIENTE: TIntegerField;
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    FDMemTable1: TFDMemTable;
    FDMemTable1bairro: TWideStringField;
    FDMemTable1cidade: TWideStringField;
    FDMemTable1logradouro: TWideStringField;
    FDMemTable1estado_info: TWideStringField;
    FDMemTable1cep: TWideStringField;
    FDMemTable1cidade_info: TWideStringField;
    FDMemTable1estado: TWideStringField;
    procedure DataModuleCreate(Sender: TObject);
    procedure QryContatoBeforeInsert(DataSet: TDataSet);
    procedure QryClienteAfterPost(DataSet: TDataSet);
    procedure QryClienteBeforeDelete(DataSet: TDataSet);
    procedure QryContatoBeforePost(DataSet: TDataSet);
    procedure QryContatoAfterPost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    Connected : boolean;
    function GetCepJson(Cep: String): String;
  end;

var
  PrincipalM: TPrincipalM;

implementation

uses
  System.IniFiles;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TPrincipalM.DataModuleCreate(Sender: TObject);
var
  ArquivoINI: TIniFile;
begin
  try
    ArquivoINI := TIniFile.Create(ExtractFilePath(Application.ExeName)+'Config.ini');


    Connected := False;

    connPrincipal.User := ArquivoIni.ReadString('DATABASE','Usuario','SYSDBA');
    connPrincipal.Password := ArquivoIni.ReadString('DATABASE','Senha','masterkey');
    connPrincipal.Port := StrToInt(ArquivoIni.ReadString('DATABASE','Porta','3050'));
    connPrincipal.Database := ArquivoIni.ReadString('DATABASE','Caminho','');
    connPrincipal.Connected := True;

    Connected := connPrincipal.Connected;
  except ON e: exception do
    Application.MessageBox(PChar('Erro ao conectar ao banco de dados!'+#13+e.Message),'Erro',16);

  end;
end;

function TPrincipalM.GetCepJson(Cep: String): String;
const
  Url = 'https://api.postmon.com.br/v1/cep/';
var
  IbgeUF, IbgeCidade: string;
  IbgeJson: TJsonValue;
begin
  try
    Result := '';
    RestClient1.BaseURL := Url + Cep;
    RESTRequest1.Execute;

    QryCliente.FieldByName('sigla_uf').AsString := FDMemTable1.FieldByName('estado').AsString;
    QryCliente.FieldByName('cidade').AsString := FDMemTable1.FieldByName('cidade').AsString;
    QryCliente.FieldByName('logradouro').AsString := FDMemTable1.FieldByName('logradouro').AsString;

    IbgeJson := TJsonObject.ParseJSONValue(FDMemTable1.FieldByName('estado_info').AsString);
    QryCliente.FieldByName('ibge_uf').AsString := IbgeJson.GetValue<String>('codigo_ibge');

    IbgeJson := TJsonObject.ParseJSONValue(FDMemTable1.FieldByName('cidade_info').AsString);
    QryCliente.FieldByName('ibge_cidade').AsString := IbgeJson.GetValue<String>('codigo_ibge');

  except on E: exception do
    Result := E.message;
  end;
end;

procedure TPrincipalM.QryClienteAfterPost(DataSet: TDataSet);
begin
  QryCliente.Close;
  QryCliente.Open;
end;

procedure TPrincipalM.QryClienteBeforeDelete(DataSet: TDataSet);
var
  QryDelContato: TZQuery;
begin
  try
    QryDelContato := TZQuery.Create(nil);
    QryDelContato.Connection := connPrincipal;
    QryDelContato.SQL.Text := 'DELETE FROM CONTATO WHERE ID_CLIENTE = '+DataSet.FieldByName('ID').AsString;
    QryDelContato.ExecSQL;
  finally
    FreeAndNil(QryDelContato);
  end;
end;

procedure TPrincipalM.QryContatoAfterPost(DataSet: TDataSet);
begin
  QryCliente.Close;
  QryCliente.Open;
end;

procedure TPrincipalM.QryContatoBeforeInsert(DataSet: TDataSet);
begin
  if not QryCliente.FieldByName('ID').AsInteger=0 then
    Exit;
end;

procedure TPrincipalM.QryContatoBeforePost(DataSet: TDataSet);
begin
  QryContato.FieldByName('id_cliente').AsInteger := QryCliente.FieldByName('ID').AsInteger;
end;


end.
