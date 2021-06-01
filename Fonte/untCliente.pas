unit untCliente;

interface

uses
  System.SysUtils, ZConnection, ZDataset;

type
  TCliente = class
  private
    FConn: TZConnection;
    FID: Integer;
    FLogradouro: String;
    FIbgeUf: String;
    FCep: String;
    FNumero: String;
    FComplemento: String;
    FNome: String;
    FCidade: String;
    FSiglaUf: String;
    FIbgeCidade: String;
  public
    constructor Create(conn: TZConnection);
    property ID: Integer read FID write FID;
    property Nome: String read FNome write FNome;
    property Cep: String read FCep write FCep;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Numero: String read FNumero write FNumero;
    property Complemento: String read FComplemento write FComplemento;
    property Cidade: String read FCidade write FCidade;
    property IbgeCidade: String read FIbgeCidade write FIbgeCidade;
    property SiglaUf: String read FSiglaUf write FSiglaUf;
    property IbgeUf: String read FIbgeUf write FIbgeUf;
    function GetCliente(out erro: string): Boolean;
 end;

implementation

{ TCliente }

constructor TCliente.Create(conn: TZConnection);
begin
  FConn := conn;
end;

function TCliente.GetCliente(out Erro: string): Boolean;
var
  Qry: TZQuery;
  PNome: String;
begin
  try
    try
      Qry := TZQuery.Create(nil);
      Qry.Connection := FConn;
      Qry.SQL.Text := 'SELECT * FROM CLIENTE WHERE upper(NOME) LIKE ''%'+Nome+'%''';
      Qry.Open;

      if not Qry.IsEmpty then
      begin
        Erro := '';
        Result := True;

        ID := Qry.FieldByName('ID').AsInteger;
        Nome := Qry.FieldByName('NOME').AsString;
        Cep := Qry.FieldByName('CEP').AsString;
        Logradouro := Qry.FieldByName('LOGRADOURO').AsString;
        Numero := Qry.FieldByName('NUMERO').AsString;
        Complemento := Qry.FieldByName('COMPLEMENTO').AsString;
        Cidade := Qry.FieldByName('CIDADE').AsString;
        IbgeCidade := Qry.FieldByName('IBGE_CIDADE').AsString;
        SiglaUf := Qry.FieldByName('SIGLA_UF').AsString;
        IbgeUf := Qry.FieldByName('IBGE_UF').AsString;
      end else begin
         erro := 'Usuário NÃO Encontrado';
         Result := False;
      end;
    except on E: exception do
      begin
        erro := 'Erro ao Pesquisar: '+E.Message;
        Result := False;
      end;
    end;
  finally
    Qry.Connection := nil;
    FreeAndNil(Qry);
  end;
end;

end.
